import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/utility/stile_text.dart';

class Messaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  Map<String, String> _messages = {};

  Messaging() {
    _firebaseMessaging.getToken().then((value) => _token = value);
    //TODO Staccare config e aggiungere context dopo aver visualizzato le notifiche in console
    _config();
  }

  String get token => _token;

  Map<String, String> get messages => _messages;

  void _config() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message.toString());
        /*showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(message['notification']['title'],
                    style: StileText.sottotitolo),
                content: Text(message['notification']['body'],
                    style: StileText.corpo),
              );
            });*/
      },
    );
    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(
      sound: true,
      alert: true,
      badge: true,
    ));
  }
}
