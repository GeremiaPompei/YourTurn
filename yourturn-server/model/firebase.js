var admin = require("firebase-admin");

var serviceAccount = require("./yourturn-9772d-firebase-adminsdk-ibn2o-e14a5a05cf.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://yourturn-9772d.firebaseio.com"
});

module.exports = admin;