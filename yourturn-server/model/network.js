var ip = require('ip');
var address = ip.address();
const port = 3000;

module.exports = {
    address,
    port,
};