const fs = require('fs');
const imagesToPdf = require("images-to-pdf");

async function convert(path, name) {
    var finalPath = path.replace('.png','.pdf');
    await imagesToPdf([path], finalPath);
    return finalPath;
}

module.exports = {
    convert,
}