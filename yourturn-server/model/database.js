const admin = require('./firebase');
const db = admin.firestore();

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
  
async function enqueue(map, ticket) {
    await db.collection('accounts').doc(map.uid).update({
      'tickets': admin.firestore.FieldValue.arrayUnion(ticket.numberid),
    });
    await db.collection('queues').doc(map.id).update({
      'tickets': admin.firestore.FieldValue.arrayUnion(ticket.numberid),
    });
    await db.collection('tickets').doc(ticket.numberid).set(ticket);
    return ticket;
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
    if(queue.index < queue.tickets.length) {
      await db.collection('queues').doc(txt).update({
        'index': queue.index + 1,
      });
    }
    return queue;
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