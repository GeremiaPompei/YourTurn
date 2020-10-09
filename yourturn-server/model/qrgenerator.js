const qrcode = require('qrcode');
const network = require('./network');

async function generate(path, name) {
    var finalpath = path+'.png';
    var strGenerated = 'http://'+network.address+':'+network.port+'/pdfqueue/'+name;
    await qrcode.toFile(finalpath, strGenerated);
    console.log('Genarated: '+strGenerated);
    return finalpath;
}

module.exports = {
    generate,
}