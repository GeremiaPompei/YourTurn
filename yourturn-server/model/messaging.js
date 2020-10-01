const admin = require('./firebase');

async function notify (token, title, body) {
  var res = await admin.messaging().sendToDevice(token,{
    notification: {
      title: title,
      body: body,
    },
  },);
  console.log('Success '+res.results);
}

module.exports = {
  notify
};