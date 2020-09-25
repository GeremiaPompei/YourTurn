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
        //log
        console.log('Enqueued ['+new Date().toLocaleString()+']');
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
    error
}