const admin = require('./firebase');

async function notify (token, title, body) {
    var res = admin.messaging().send({
      notification: {
        title: title,
        body: body,
      },
      token: token
    });
    console.log('Success '+res.results);
}

module.exports = {
    notify
};