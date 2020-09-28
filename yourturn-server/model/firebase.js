const { text } = require("body-parser");
var admin = require("firebase-admin");

var serviceAccount = require("./yourturn-9772d-firebase-adminsdk-ibn2o-e14a5a05cf.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://yourturn-9772d.firebaseio.com"
});

const db = admin.firestore();
const converter = require("./ticketnumber_converter");

async function signIn(map) {
  var result = await db.collection('accounts').doc(map.uid).set(map);
  return result;
}

async function logIn(map) {
  var txt = map.uid.replace('/');
  var result = (await (db.collection('accounts').doc(txt).get())).data();
  return result;
}

async function createQueue(map) {
  var result = await db.collection('queues').doc(map.id).set(map);
  await db.collection('accounts').doc(map.admin).update({
    'myqueues': admin.firestore.FieldValue.arrayUnion(map.id),
  });
  return result;
}

async function enqueue(map) {
  await db.collection('accounts').doc(map.user).update({
    'tickets': admin.firestore.FieldValue.arrayUnion(map.numberid),
  });
  await db.collection('queues').doc(map.queue).update({
    'queue': admin.firestore.FieldValue.arrayUnion(map.numberid),
  });
  return await db.collection('tickets').doc(map.numberid).set(map);
}

async function getTicket(map) {
  var txt = map.numberid.replace('/');
  var result = (await (db.collection('tickets').doc(txt).get())).data();
  return result;
}

async function setTicket(map) {
  return await db.collection('tickets').doc(map.numberid).set(map);
}

async function getQueue(map) {
  var txt = map.id.replace('/');
  var result = (await (db.collection('queues').doc(txt).get())).data();
  return result;
}

async function next(map) {
  var txt = map.id.replace('/');
  var queue = (await db.collection('queues').doc(txt).get()).data();
  if(queue.index < queue.queue.length) {
    await db.collection('queues').doc(txt).update({
      'index': queue.index + 1,
    });
    //notifica
    if(queue.index < queue.queue.length) notify(queue.queue[queue.index],queue.id,'E\' il tuo turno');
    if(queue.index + 1 < queue.queue.length) notify(queue.queue[queue.index + 1],queue.id,'Manca una persona prima di te');
    if(queue.index + 2 < queue.queue.length) notify(queue.queue[queue.index + 2],queue.id,'Mancano due persone prima di te');
  }
  return txt;
}

async function notify(i,title,body) {
  var ticket = (await db.collection('tickets').doc(i).get()).data();
  var user = (await db.collection('accounts').doc(ticket.user).get()).data();
  admin.messaging().send({
    notification: {
      title: title,
      body: body,
    },
    token: user.tokenid})
    .then((res)=>{console.log('Success '+res.results)});
}

module.exports = {
  signIn,
  logIn,
  createQueue,
  enqueue,
  getQueue,
  getTicket,
  setTicket,
  next
};