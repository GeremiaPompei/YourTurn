const { json } = require('express');
const controller = require('./controller');
const express = require('express');
var bodyParser = require('body-parser');
var jsonParser = bodyParser.json();
const router = express.Router();

router.post('/signin', jsonParser, controller.signIn);
router.use(controller.error);

module.exports = router;
