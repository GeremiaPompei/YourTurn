import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingFunctions {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  List<Map<String, String>> _messages = [];
  List<String> _listIndex = ['0'];

  MessagingFunctions() {
    _firebaseMessaging.getToken().then((value) => _token = value);
    _config();
  }

  List<String> get listIndex => _listIndex;

  String get token => _token;

  void _config() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message.toString());
        setState() {
          if (message['notification']['title'] == 'index') {
            _listIndex.add(message['notification']['body']);
          } else {
            _messages.add(message['notification']);
          }
        }
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
