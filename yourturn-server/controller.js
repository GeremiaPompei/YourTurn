const db = require('./model/database');
const messaging = require('./model/messaging');
const user = require('./model/user');
const queue = require('./model/queue');
const ticket = require('./model/ticket');
const convert = require('./model/ticketnumber_converter');
const qrgenerator = require('./model/qrgenerator');
const pdfconverter = require('./model/pdfconverter');
const fs = require('fs');
const pathQrFiles = __dirname+'/qrfiles/';
const blackListChars = ['/','\'','\"',';','(',')','[',']','{','}']

async function createUser(req,res) {
    var value;
    if(checkText(req.body)) {
        var _user = user.fromJson(req.body.uid, req.body.tokenid, req.body.nome, req.body.cognome
            , req.body.annonascita, req.body.sesso, req.body.email, req.body.telefono);
        value = await db.createUser(_user);
    }
    res.send(value);
    //log
    console.log('User created ['+new Date().toLocaleString()+']');
    console.log(value);
}  

async function getUser(req,res) {
    var _user;
    if(checkText(req.body)) {
        _user = await db.getUser(req.body);
        if(_user == null)
            res.send(null);
        if(_user.queue!=null)
            _user.queue = await db.getQueue({'id': _user.queue});
        for (var i = 0; i < _user.tickets.length; i++) {
            _user.tickets[i] = await db.getTicket({'numberid': _user.tickets[i]});
            _user.tickets[i].queue = await db.getQueue({'id': _user.tickets[i].queue});
            _user.tickets[i].queue.admin = await db.getUser({'uid':  _user.tickets[i].queue.admin});
        }
    }
    res.send(_user);
    //log
    console.log('User getted ['+new Date().toLocaleString()+']');
    console.log(_user);
}

async function removeUser(req,res) {
    var _user;
    if(checkText(req.body))
        _user = await db.removeUser(req.body);
    res.send(_user);
    //log
    console.log('User removed ['+new Date().toLocaleString()+']');
    console.log(req.body);
}

async function addTokenidUser(req,res) {
    var value;
    if(checkText(req.body))
        value = await db.addTokenidUser(req.body);
    res.send(value);
    //log
    console.log('User tokenid added ['+new Date().toLocaleString()+']');
    console.log(req.body);
}

async function removeTokenidUser(req,res) {
    var value;
    if(checkText(req.body))
        value = await db.removeTokenidUser(req.body);
    res.send(value);
    //log
    console.log('User tokenid removed ['+new Date().toLocaleString()+']');
    console.log(req.body);
}

async function createQueue(req,res) {
    var value;
    console.log(req.body);
    if(checkText(req.body)) {
        var _queue = queue.fromJson(req.body.id, req.body.luogo, req.body.uid);
        value = await db.createQueue(_queue);
        fs.mkdirSync(pathQrFiles, { recursive: true });
        var pathJpg = await qrgenerator.generate(pathQrFiles+value.id);
        pdfconverter.convert(pathJpg, req.body.id);
        fs.unlinkSync(pathJpg);
    }
    res.send(value);
    //log
    console.log('Queue created ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function getQueue(req,res) {
    var value;
    if(checkText(req.body))
        value = await db.getQueue(req.body);
    res.send(value);
    //log
    console.log('Queue getted ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function closeQueue(req,res) {
    var value;
    if(checkText(req.body)) {
        value = await db.getQueue(req.body);
        fs.unlinkSync(pathQrFiles+value.id+'.pdf');
        //notifica
        for (var i = value.index; i < value.tickets.length; i++)
            notify(value.tickets[i],value.id,'La coda è terminata');
        value = await db.removeQueue(req.body);
    }
    res.send(value);
    //log
    console.log('Queue closed ['+new Date().toLocaleString()+']');
    console.log(req.body);
}

async function enqueue(req,res) {
    var value;
    if(checkText(req.body)) {
        var _queue = await db.getQueue({'id': req.body.id});
        var _ticket = ticket.fromJson(req.body.uid, req.body.id, req.body.id + '-' + convert.fromInt(_queue.tickets.length + 1));
        value = await db.enqueue(_ticket);
        value.queue = await db.getQueue({'id': value.queue});
        value.queue.admin = await db.getUser({'uid': value.queue.admin});
    }
    res.send(value);
    //log
    console.log('Enqueued ['+new Date().toLocaleString()+']');
    console.log(value);
}

async function getTicket(req,res) {
    var _ticket;
    if(checkText(req.body))
        _ticket = await db.getTicket(req.body);
    res.send(_ticket);
    //log
    console.log('Ticket getted ['+new Date().toLocaleString()+']');
    console.log(_ticket);
}

async function next(req,res) {
    var _queue;
    if(checkText(req.body)) {
        _queue = await db.next(req.body);
        console.log(_queue);
        _queue.tickets[_queue.index-1] = await db.getTicket({'numberid': _queue.tickets[_queue.index-1]});
        _queue.tickets[_queue.index-1].user = await db.getUser({'uid': _queue.tickets[_queue.index-1].user});
        //notifica
        if(_queue.index - 1 < _queue.tickets.length) 
            notify(_queue.tickets[_queue.index - 1].numberid,_queue.id,'E\' il tuo turno');
        if(_queue.index  < _queue.tickets.length) 
            notify(_queue.tickets[_queue.index].numberid,_queue.id,'Manca una persona prima di te');
        if(_queue.index + 1 < _queue.tickets.length) 
            notify(_queue.tickets[_queue.index + 1].numberid,_queue.id,'Mancano due persone prima di te');
        }
        res.send(_queue);
    //log
    console.log('User next ['+new Date().toLocaleString()+']');
    console.log(_queue);
}
  
async function notify(ticketid,title,body) {
  var _ticket = await db.getTicket({'numberid': ticketid});
  var _user = await db.getUser({'uid': _ticket.user});
  for (var i = 0; i < _user.tokenid.length; i++) {
    try {
        await messaging.notify(_user.tokenid[i], title, body);
    } catch(e) {
        db.removeTokenidUser({'uid': _user.uid,'tokenid': _user.tokenid[i]});
    }
  }
}

async function getQueuePdf(req,res) {
    res.sendFile(pathQrFiles+req.params.id+'.pdf');
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

function checkText(map) {
    var bool = true;
    Array.from(Object.values(map)).forEach(value => {
        blackListChars.forEach(char => {
            if(value.includes(char))
                bool = false;
            });
        });
    return bool;
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
    closeQueue,
    getTicket,
    next,
    getQueuePdf,
    test,
    error
}