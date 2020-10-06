const qrcode = require('qrcode');
const network = require('./network');
const route = require('../route');

async function generate(name) {
    var finalpath = name+'.jpg';
    var genarated = await qrcode.toFile(finalpath, 'http://'+network.address+':'+network.port+'/'+route.pathQueue+'/'+name);
    console.log(genarated);
    return finalpath;
}

module.exports = {
    generate,
}