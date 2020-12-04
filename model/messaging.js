const admin = require('./firebase');

async function notify (token, title, body) {
  var notification = {
    notification: {
      title: title,
      body: body,
    },
    token: token,
  };
  await admin.messaging().send(notification);
  console.log('Success');
  console.log(notification);
}

module.exports = {
  notify
};