const db = require('./model/firebase');

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

const enqueue = (req,res) => {
    db.enqueue(req.body)
    .then((value) => {
        res.send('Enqueued');
        //notifica
        //log
        console.log('Enqueued ['+new Date().toLocaleString()+']');
        console.log(req.body);
    });
};

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
        console.log(value);
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
    .then((value) => {
        res.send(value);
        //notifica
        //log
        console.log('User next ['+new Date().toLocaleString()+']');
        console.log(value);
    });
};

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