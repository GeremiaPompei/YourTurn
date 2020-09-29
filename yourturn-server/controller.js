const db = require('./model/database');
const messaging = require('./model/messaging');
const ticket = require('./model/ticket');
const convert = require('./model/ticketnumber_converter');

const signIn = (req,res) => {
    db.signIn(req.body)
    .then((value) => {
        res.send('Signed');
        //log
        console.log('Signed ['+new Date().toLocaleString()+']');
        console.log(req.body);
    });
};

const logIn = (req,res) => {
    db.logIn(req.body)
    .then((value) => {
        res.send(value);
        //log
        console.log('Logged ['+new Date().toLocaleString()+']');
        console.log(value);
    });
};

const createQueue = (req,res) => {
    db.createQueue(req.body)
    .then((value) => {
        res.send(value);
        //log
        console.log('Queue created ['+new Date().toLocaleString()+']');
        console.log(req.body);
    });
};

async function enqueue(req,res) {
    var queue = await db.getQueue({'id': req.body.id});
    var _ticket = ticket.fromJson(req.body.uid, req.body.id, req.body.id + '-' + convert.fromInt(queue.tickets.length + 1));
    var value = await db.enqueue(req.body, _ticket)
    res.send(value);
    //notifica
    //log
    console.log('Enqueued ['+new Date().toLocaleString()+']');
    console.log(value);
}

const getTicket = (req,res) => {
    db.getTicket(req.body)
    .then((value) => {
        res.send(value);
        //log
        console.log('Ticket getted ['+new Date().toLocaleString()+']');
        console.log(value);
    });
};

const setTicket = (req,res) => {
    db.setTicket(req.body)
    .then((value) => {
        res.send(value);
        //log
        console.log('Ticket setted ['+new Date().toLocaleString()+']');
        console.log(req.body);
    });
};

const getQueue = (req,res) => {
    db.getQueue(req.body)
    .then((value) => {
        res.send(value);
        //log
        console.log('Queue getted ['+new Date().toLocaleString()+']');
        console.log(value);
    });
};

const next = (req,res) => {
    db.next(req.body)
    .then((queue) => {
        res.send(queue);
        //notifica
        if(queue.index < queue.queue.length) notify(queue.queue[queue.index],queue.id,'E\' il tuo turno');
        if(queue.index + 1 < queue.queue.length) notify(queue.queue[queue.index + 1],queue.id,'Manca una persona prima di te');
        if(queue.index + 2 < queue.queue.length) notify(queue.queue[queue.index + 2],queue.id,'Mancano due persone prima di te');
        //log
        console.log('User next ['+new Date().toLocaleString()+']');
        console.log(queue);
    });
};
  
async function notify(ticketid,title,body) {
  var ticket = await db.getTicket({'numberid': ticketid});
  var user = await db.logIn({'uid': ticket.user});
  return await messaging.notify(user.tokenid, title, body);
}

const test = (req,res)=> {
    res.send('Success');
    //log
    console.log('Test ['+new Date().toLocaleString()+']');
};

const error = (req,res)=> {
    res.statusCode = 404;
    res.send('Error 404');
    //log
    console.log('Error 404 ['+new Date().toLocaleString()+']');
    console.log(req.body);
};

module.exports = {
    signIn,
    logIn,
    createQueue,
    enqueue,
    getQueue,
    getTicket,
    setTicket,
    next,
    test,
    error
}