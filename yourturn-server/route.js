const express = require('express');
var bodyParser = require('body-parser');
const controller = require('./controller');
const router = express.Router();


router.post('/addtokeniduser', bodyParser.json(), controller.addTokenidUser);
router.post('/removetokeniduser', bodyParser.json(), controller.removeTokenidUser);
router.post('/enqueue', bodyParser.json(), controller.enqueue);
router.post('/next', bodyParser.json(), controller.next);
router.put('/createqueue', bodyParser.json(), controller.createQueue);
router.put('/createuser', bodyParser.json(), controller.createUser);
router.delete('/closequeue/:id', controller.closeQueue);
router.delete('/removeuser/:id', controller.removeUser);
router.get('/getuser/:id', controller.getUser);
router.get('/getqueue/:id', controller.getQueue);
router.get('/getticket/:id', controller.getTicket);
router.get('/blacklistchars', controller.getBlackListChars);
router.get('/pdfqueue/:id', controller.getQueuePdf);
router.get('/test', controller.test);
router.use(controller.error);

module.exports = router;
