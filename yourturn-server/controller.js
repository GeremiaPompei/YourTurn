const db = require('./model/database');
const messaging = require('./model/messaging');
const user = require('./model/user');
const queue = require('./model/queue');
const ticket = require('./model/ticket');
const convert = require('./model/ticketnumber_converter');
const e = require('express');

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
    for (var i = 0; i < value.myqueues.length; i++) {
        value.myqueues[i] = await db.getQueue({'id': value.myqueues[i]});
        if(i != value.myqueues.length-1) {
            if(value.myqueues[i].stopdatetime==null) {
                value.myqueues[i].stopdatetime=new Date().toISOString();
                db.closeQueue(value.myqueues[i]);
            }
        }
        for (var j = 0; j < value.myqueues[i].tickets.length; j++) {
            value.myqueues[i].tickets[j] = await db.getTicket({'numberid': value.myqueues[i].tickets[j]});
            if(j != value.myqueues[i].tickets.length-1) {
                if(value.myqueues[i].tickets[j].stopenqueue==null) {
                    value.myqueues[i].tickets[j].stopenqueue=value.myqueues[i].stopdatetime;
                    db.setTicket(value.myqueues[i].tickets[j]);
                }
            }
        }
    }
    for (var i = 0; i < value.tickets.length; i++) {
        value.tickets[i] = await db.getTicket({'numberid': value.tickets[i]});
        value.tickets[i].queue = await db.getQueue({'id': value.tickets[i].queue});
        value.tickets[i].queue.admin = await db.getUser({'uid':  value.tickets[i].queue.admin});
        if(i != value.tickets.length-1) {
            if(value.tickets[i].queue.stopdatetime==null) {
                value.tickets[i].queue.stopdatetime=new Date().toISOString();
                db.setQueue(value.tickets[i].queue);
            }
            if(value.tickets[i].stopenqueue==null) {
                value.tickets[i].stopenqueue=value.tickets[i].queue.stopdatetime;
                db.setTicket(value.tickets[i]);
            }
        }
    }
    res.send(value);
    //log
    console.log('User getted ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function addTokenidUser(req,res) {
    var value = await db.addTokenidUser(req.body);
    res.send(value);
    //log
    console.log('User tokenid added ['+new Date().toLocaleString()+']');
    console.log(req.body);
}

async function removeTokenidUser(req,res) {
    var value = await db.removeTokenidUser(req.body);
    res.send(value);
    //log
    console.log('User tokenid removed ['+new Date().toLocaleString()+']');
    console.log(req.body);
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

async function closeQueue(req,res) {
    var value = await db.closeQueue(req.body);
    res.send(value);
    //log
    console.log('Queue setted ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function closeTicket(req,res) {
    var value = await db.closeTicket(req.body);
    res.send(value);
     //log
    console.log('Ticket closed ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function getQueue(req,res) {
    var value = await db.getQueue(req.body);
    res.send(value);
    //log
    console.log('Queue getted ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function setQueue(req,res) {
    var value = await db.closeQueue(req.body);
    res.send(value);
    //log
    console.log('Queue closed ['+new Date().toLocaleString()+']');
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
  for (var i = 0; i < user.tokenid.length; i++) {
    try {
        await messaging.notify(user.tokenid[i], title, body);
    } catch(e) {
        db.removeTokenidUser({'uid': user.uid,'tokenid': user.tokenid[i]});
    }
  }
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
    addTokenidUser,
    removeTokenidUser,
    createQueue,
    enqueue,
    getQueue,
    closeQueue,
    getTicket,
    closeTicket,
    next,
    test,
    error
}