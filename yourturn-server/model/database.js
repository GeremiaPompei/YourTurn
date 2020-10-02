const admin = require('./firebase');
const db = admin.firestore();

const tabUsers = 'users';
const tabQueues = 'queues';
const tabTickets = 'tickets';

async function createUser(map) {
  await db.collection(tabUsers).doc(map.uid).set(map);
  return map;
}
  
async function getUser(map) {
  var txt = map.uid.replace('/');
  var result = (await (db.collection(tabUsers).doc(txt).get())).data();
  return result;
}
  
async function addTokenidUser(map) {
  await db.collection(tabUsers).doc(map.uid).update({
    'tokenid': admin.firestore.FieldValue.arrayUnion(map.tokenid),
  });
}
  
async function removeTokenidUser(map) {
  await db.collection(tabUsers).doc(map.uid).update({
    'tokenid': admin.firestore.FieldValue.arrayRemove(map.tokenid),
  });
}
  
async function createQueue(map) {
  await db.collection(tabQueues).doc(map.id).set(map);
  await db.collection(tabUsers).doc(map.admin).update({
    'myqueues': admin.firestore.FieldValue.arrayUnion(map.id),
  });
  return map;
}
  
async function getQueue(map) {
  var txt = map.id.replace('/');
  var result = (await (db.collection(tabQueues).doc(txt).get())).data();
  return result;
}
  
async function removeQueue(map) {
  var doc = db.collection(tabQueues).doc(map.id);
  var _queue = (await doc.get()).data();
  await db.collection(tabUsers).doc(_queue.admin).update({
    'myqueues': admin.firestore.FieldValue.arrayRemove(_queue.id),
  });
  for (var i = 0; i < _queue.tickets.length; i++)
    await removeTicket({'numberid': _queue.tickets[i]});
  return await doc.delete();
}
  
async function next(map) {
  var txt = map.id.replace('/');
  var doc = await db.collection(tabQueues).doc(txt);
  var queue = (await doc.get()).data();
  if(queue.index < queue.tickets.length) {
    await doc.update({
      'index': queue.index + 1,
    });
  }
  await removeTicket({'numberid': queue.tickets[queue.index]});
  return (await doc.get()).data();
}
  
async function removeTicket(map) {
  var doc = db.collection(tabTickets).doc(map.numberid);
  var _ticket = (await doc.get()).data();
  await db.collection(tabUsers).doc(_ticket.user).update({
    'tickets': admin.firestore.FieldValue.arrayRemove(_ticket.numberid),
  });
  return await doc.delete();
}
  
async function enqueue(map) {
  await db.collection(tabUsers).doc(map.user).update({
    'tickets': admin.firestore.FieldValue.arrayUnion(map.numberid),
  });
  await db.collection(tabQueues).doc(map.queue).update({
    'tickets': admin.firestore.FieldValue.arrayUnion(map.numberid),
  });
  await db.collection(tabTickets).doc(map.numberid).set(map);
  return map;
}
  
async function getTicket(map) {
  var txt = map.numberid.replace('/');
  var result = (await (db.collection(tabTickets).doc(txt).get())).data();
  return result;
}

async function setTicket(map) {
  await (db.collection(tabTickets).doc(map.numberid).set(map));
}
  
module.exports = {
  createUser,
  getUser,
  addTokenidUser,
  removeTokenidUser,
  createQueue,
  enqueue,
  getQueue,
  removeQueue,
  getTicket,
  setTicket,
  next
};