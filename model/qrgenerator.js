require('dotenv').config();
const qrcode = require('qrcode');


async function generate(path, name) {
    var finalpath = path+'.png';
    var strGenerated = process.env.URL+'pdfqueue/'+name;
    await qrcode.toFile(finalpath, strGenerated);
    console.log('Genarated: '+strGenerated);
    return finalpath;
}

module.exports = {
    generate,
}
