const express = require('express');
var bodyParser = require('body-parser');
const controller = require('./controller');
const router = express.Router();

router.post('/createuser', bodyParser.json(), controller.createUser);
router.post('/getuser', bodyParser.json(), controller.getUser);
router.post('/removeuser', bodyParser.json(), controller.removeUser);
router.post('/addtokeniduser', bodyParser.json(), controller.addTokenidUser);
router.post('/removetokeniduser', bodyParser.json(), controller.removeTokenidUser);
router.post('/createqueue', bodyParser.json(), controller.createQueue);
router.post('/enqueue', bodyParser.json(), controller.enqueue);
router.post('/getqueue', bodyParser.json(), controller.getQueue);
router.post('/closequeue', bodyParser.json(), controller.closeQueue);
router.post('/getticket', bodyParser.json(), controller.getTicket);
router.post('/next', bodyParser.json(), controller.next);
router.get('/queue/:id', controller.getQueuePdf)
router.get('/test', controller.test)
router.use(controller.error);

module.exports = router;
