const { text } = require("body-parser");
var admin = require("firebase-admin");

var serviceAccount = require("./yourturn-9772d-firebase-adminsdk-ibn2o-e14a5a05cf.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://yourturn-9772d.firebaseio.com"
});

const db = admin.firestore();

async function signIn(map) {
  var result = await db.collection('accounts').doc(map.uid).set(map);
  /*notifica
  admin.messaging()
  .sendToDevice(map.tokenid,{data: {MyKey1: 'Signed'}},{priority: 'high',timeToLive: 60*60*24})
  .then((res)=>{console.log('Success '+res.results)});*/
  return result;
}

async function logIn(map) {
  var txt = map.uid.replace('/');
  var result = (await (db.collection('accounts').doc(txt).get())).data();
  /*notifica
  admin.messaging()
  .sendToDevice(result.tokenid,{data: {MyKey1: 'Logged'}},{priority: 'high',timeToLive: 60*60*24})
  .then((res)=>{console.log('Success '+res.results)});*/
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
  var txt = map.number.replace('/');
  var result = (await (db.collection('tickets').doc(txt).get())).data();
  return result;
}

async function getQueue(map) {
  var txt = map.id.replace('/');
  var result = (await (db.collection('queues').doc(txt).get())).data();
  return result;
}

module.exports = {
  signIn,
  logIn,
  createQueue,
  enqueue,
  getQueue,
  getTicket
};