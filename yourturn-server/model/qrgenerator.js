const qrcode = require('qrcode');
const network = require('./network');
const route = require('../route');

async function generate(name) {
    var finalpath = name+'.png';
    await qrcode.toFile(finalpath, 'http://'+network.address+':'+network.port+'/'+route.pathQueue+'/'+name);
    console.log('Genarated: '+finalpath);
    return finalpath;
}

module.exports = {
    generate,
}