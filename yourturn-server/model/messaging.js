const admin = require('./firebase');

async function notify (token, title, body) {
    admin.messaging().send({
      notification: {
        title: title,
        body: body,
      },
      token: token
    })
    .then((res)=>{console.log('Success '+res.results)});
}

module.exports = {
    notify
};