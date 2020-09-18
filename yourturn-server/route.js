const express = require('express');
const router = express.Router();

const welcome = __dirname+'/welcome.html'

router.get('/', (req,res) => res.send('welcome'));
router.use((req,res)=> {
    res.statusCode = 404;
    res.send('Error 404');
});

module.exports = router;
