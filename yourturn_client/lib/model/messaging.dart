import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/pushnotification_view.dart';

class Messaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  Map<String, String> _messages;

  Messaging() {
    _messages = {};
    _firebaseMessaging.getToken().then((value) => _token = value);
  }

  String get token => _token;

  Map<String, String> get messages => _messages;

  void config(context, Future<void> Function() update) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showDialog(
            context: context,
            builder: (context) {
              update().then((value) {
                (context as Element).reassemble();
              });
              return PushNotificationView(message['notification']['title'],
                  message['notification']['body']);
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
