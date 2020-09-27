const { json } = require('express');
const controller = require('./controller');
const express = require('express');
var bodyParser = require('body-parser');
const router = express.Router();

router.post('/signin', bodyParser.json(), controller.signIn);
router.post('/login', bodyParser.json(), controller.logIn);
router.post('/createqueue', bodyParser.json(), controller.createQueue);
router.post('/enqueue', bodyParser.json(), controller.enqueue);
router.post('/getqueue', bodyParser.json(), controller.getQueue);
router.post('/getticket', bodyParser.json(), controller.getTicket);
router.post('/setticket', bodyParser.json(), controller.setTicket);
router.post('/next', bodyParser.json(), controller.next);
router.get('/test', controller.test)
router.use(controller.error);

module.exports = router;
