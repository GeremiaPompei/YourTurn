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
  
async function setUser(map) {
    return await db.collection(tabUsers).doc(map.uid).set(map);
}
  
async function createQueue(map) {
    await db.collection(tabQueues).doc(map.id).set(map);
    await db.collection(tabUsers).doc(map.admin).update({
      'myqueues': admin.firestore.FieldValue.arrayUnion(map.id),
    });
    return map;
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
    return await db.collection(tabTickets).doc(map.numberid).set(map);
}
  
async function getQueue(map) {
    var txt = map.id.replace('/');
    var result = (await (db.collection(tabQueues).doc(txt).get())).data();
    return result;
}
  
async function setQueue(map) {
    return await db.collection(tabQueues).doc(map.id).set(map);
}
  
async function next(map) {
    var txt = map.id.replace('/');
    var queue = (await db.collection(tabQueues).doc(txt).get()).data();
    if(queue.index < queue.tickets.length) {
      await db.collection(tabQueues).doc(txt).update({
        'index': queue.index + 1,
      });
    }
    return queue;
}
  
module.exports = {
    createUser,
    getUser,
    setUser,
    createQueue,
    enqueue,
    getQueue,
    setQueue,
    getTicket,
    setTicket,
    next
};