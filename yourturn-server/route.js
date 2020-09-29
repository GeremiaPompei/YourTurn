const express = require('express');
var bodyParser = require('body-parser');
const controller = require('./controller');
const router = express.Router();

router.post('/createuser', bodyParser.json(), controller.createUser);
router.post('/getuser', bodyParser.json(), controller.getUser);
router.post('/setuser', bodyParser.json(), controller.setUser);
router.post('/createqueue', bodyParser.json(), controller.createQueue);
router.post('/enqueue', bodyParser.json(), controller.enqueue);
router.post('/getqueue', bodyParser.json(), controller.getQueue);
router.post('/setqueue', bodyParser.json(), controller.setQueue);
router.post('/getticket', bodyParser.json(), controller.getTicket);
router.post('/setticket', bodyParser.json(), controller.setTicket);
router.post('/next', bodyParser.json(), controller.next);
router.get('/test', controller.test)
router.use(controller.error);

module.exports = router;
