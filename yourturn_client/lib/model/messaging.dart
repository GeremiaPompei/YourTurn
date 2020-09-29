import 'package:firebase_messaging/firebase_messaging.dart';

class Messaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  List<Map<String, String>> _messages = [];

  Messaging() {
    _firebaseMessaging.getToken().then((value) => _token = value);
    _config();
  }

  String get token => _token;

  List<Map<String, String>> get messages => _messages;

  void _config() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message.toString());
        _messages.add(message['notification']);
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
