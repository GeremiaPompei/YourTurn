import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/utility/stile_text.dart';

class Messaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  Map<String, String> _messages = {};

  Messaging() {
    _firebaseMessaging.getToken().then((value) => _token = value);
  }

  String get token => _token;

  Map<String, String> get messages => _messages;

  void config(context) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(message['title'],
                    style: StileText.sottotitolo),
                content: Text(message['body'],
                    style: StileText.corpo),
              );
            });
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
