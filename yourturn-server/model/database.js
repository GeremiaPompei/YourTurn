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
  var result = (await (db.collection(tabUsers).doc(map.uid).get())).data();
  return result;
}
  
async function removeUser(map) {
  var doc = db.collection(tabUsers).doc(map.uid);
  var _user = await doc.get();
  for(var _ticket in _user.tickets) {
    await db.collection(tabTickets).doc(_ticket).update({
      'user': null,
    });
  }
  await doc.delete();
  return 'Deleted';
}
  
async function addTokenidUser(map) {
  await db.collection(tabUsers).doc(map.uid).update({
    'tokenid': admin.firestore.FieldValue.arrayUnion(map.tokenid),
  });
  return 'Token added';
}
  
async function removeTokenidUser(map) {
  await db.collection(tabUsers).doc(map.uid).update({
    'tokenid': admin.firestore.FieldValue.arrayRemove(map.tokenid),
  });
  return 'Token Removed';
}
  
async function createQueue(map) {
  var doc = db.collection(tabQueues).doc(map.id);
  await doc.set(map);
  await db.collection(tabUsers).doc(map.admin).update({
    'queue': map.id,
  });
  return (await doc.get()).data();
}
  
async function getQueue(map) {
  var result = (await (db.collection(tabQueues).doc(map.id).get())).data();
  return result;
}
  
async function removeQueue(map) {
  var doc = db.collection(tabQueues).doc(map.id);
  var _queue = (await doc.get()).data();
  for (var i = 0; i < _queue.tickets.length; i++)
    await removeTicket({'numberid': _queue.tickets[i]});
  await db.collection(tabUsers).doc(_queue.admin).update({
    'queue': null,
  });
  await doc.delete();
  return 'Queue removed';
}
  
async function next(map) {
  var doc = await db.collection(tabQueues).doc(map.id);
  var _queue = (await doc.get()).data();
  if(_queue.index < _queue.tickets.length) {
    await doc.update({
      'index': _queue.index + 1,
    });
  }
  if(_queue.index>0){
    var _ticket = (await db.collection(tabTickets).doc(_queue.tickets[_queue.index-1]).get()).data();
    await db.collection(tabUsers).doc(_ticket.user).update({
      'tickets': admin.firestore.FieldValue.arrayRemove(_ticket.numberid),
    });
  }
  return (await doc.get()).data();
}
  
async function removeTicket(map) {
  var doc = db.collection(tabTickets).doc(map.numberid);
  var _ticket = (await doc.get()).data();
  await db.collection(tabUsers).doc(_ticket.user).update({
    'tickets': admin.firestore.FieldValue.arrayRemove(_ticket.numberid),
  });
  await doc.delete();
  return 'Ticket removed';
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
  var result = (await (db.collection(tabTickets).doc(map.numberid).get())).data();
  return result;
}

async function setTicket(map) {
  var doc = db.collection(tabTickets).doc(map.numberid);
  await doc.set(map);
  return (await doc.get()).data();
}
  
module.exports = {
  createUser,
  getUser,
  removeUser,
  addTokenidUser,
  removeTokenidUser,
  createQueue,
  enqueue,
  getQueue,
  removeQueue,
  getTicket,
  setTicket,
  next,
};