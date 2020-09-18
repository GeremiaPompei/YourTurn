const express = require('express');
const route = require('./route')
const app = express();
const port = 3000;

app.use(route);

app.listen(port,()=>console.log('You are connected to port: '+port));