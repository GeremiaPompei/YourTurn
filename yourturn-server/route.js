const { json } = require('express');
const controller = require('./controller');
const express = require('express');
var bodyParser = require('body-parser');
const router = express.Router();

router.post('/signin', bodyParser.json(), controller.signIn);
router.post('/login', bodyParser.json(), controller.logIn);
router.use(controller.error);

module.exports = router;
