const db = require('./model/database');
const messaging = require('./model/messaging');
const user = require('./model/user');
const queue = require('./model/queue');
const ticket = require('./model/ticket');
const convert = require('./model/ticketnumber_converter');

async function createUser(req,res) {
    var _user = user.fromJson(req.body.uid, req.body.tokenid, req.body.nome, req.body.cognome
        , req.body.annonascita, req.body.sesso, req.body.email, req.body.telefono);
    var value = await db.createUser(_user);
    res.send(value);
    //log
    console.log('User created ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function getUser(req,res) {
    var value = await db.getUser(req.body);
    res.send(value);
    //log
    console.log('User getted ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function setUser(req,res) {
    var value = await db.setUser(req.body);
    res.send(value);
    //log
    console.log('User setted ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function createQueue(req,res) {
    var _queue = queue.fromJson(req.body.id, req.body.luogo, req.body.uid);
    var value = await db.createQueue(_queue);
    res.send(value);
    //log
    console.log('Queue created ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function enqueue(req,res) {
    var _queue = await db.getQueue({'id': req.body.id});
    var _ticket = ticket.fromJson(req.body.uid, req.body.id, req.body.id + '-' + convert.fromInt(_queue.tickets.length + 1));
    var value = await db.enqueue(_ticket)
    res.send(value);
    //notifica
    //log
    console.log('Enqueued ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function getTicket(req,res) {
    var value = await db.getTicket(req.body);
    res.send(value);
    //log
    console.log('Ticket getted ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function setTicket(req,res) {
    var value = await db.setTicket(req.body);
    res.send(value);
     //log
    console.log('Ticket setted ['+new Date().toLocaleString()+']');
    console.log(req.body);
}

async function getQueue(req,res) {
    var value = await db.getQueue(req.body);
    res.send(value);
    //log
    console.log('Queue getted ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function setQueue(req,res) {
    var value = await db.setQueue(req.body);
    res.send(value);
    //log
    console.log('Queue setted ['+new Date().toLocaleString()+']');
    console.log(req.body);
}

async function next(req,res) {
    var queue = await db.next(req.body);
    res.send(queue);
    //notifica
    if(queue.index < queue.tickets.length) notify(queue.tickets[queue.index],queue.id,'E\' il tuo turno');
    if(queue.index + 1 < queue.tickets.length) notify(queue.tickets[queue.index + 1],queue.id,'Manca una persona prima di te');
    if(queue.index + 2 < queue.tickets.length) notify(queue.tickets[queue.index + 2],queue.id,'Mancano due persone prima di te');
    //log
    console.log('User next ['+new Date().toLocaleString()+']');
    console.log(queue);
}
  
async function notify(ticketid,title,body) {
  var ticket = await db.getTicket({'numberid': ticketid});
  var user = await db.getUser({'uid': ticket.user});
  return await messaging.notify(user.tokenid, title, body);
}

function test(req,res) {
    res.send('Success');
    //log
    console.log('Test ['+new Date().toLocaleString()+']');
}

function error(req,res) {
    res.statusCode = 404;
    res.send('Error 404');
    //log
    console.log('Error 404 ['+new Date().toLocaleString()+']');
    console.log(req.body);
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
    next,
    test,
    error
}