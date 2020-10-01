const admin = require('./firebase');

async function notify (token, title, body) {
  var res = await admin.messaging().sendToDevice({
    notification: {
      title: title,
      body: body,
    },
    data: {
      title: title,
      body: body,
    },
    token: token,
  });
  console.log('Success '+res.results);
}

module.exports = {
  notify
};