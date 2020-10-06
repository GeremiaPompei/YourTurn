const PDFDocument = require('pdfkit');
const fs = require('fs');
const doc = new PDFDocument({ size: 'A4' });


function convert(path, name) {
    var finalPath = path.replace('.jpg','.pdf');
    doc.pipe(fs.createWriteStream(finalPath));
    doc.fontSize(30).text(name,100,100);
    doc.image(path, {
        fit: [420, 420],
        align: 'center',
        valign: 'center'
      });
    doc.fontSize(15).text('YourTurn',420,650);
    doc.end();
    return finalPath;
}

module.exports = {
    convert,
}