const express = require('express');
const route = require('./route');
const app = express();
const network = require('./model/network');

app.use(route.router);

app.listen(network.port,()=>console.log('You are connected: '+network.address+':'+network.port));