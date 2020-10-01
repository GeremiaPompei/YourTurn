import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/view/authenticate_view.dart';
import 'package:yourturn_client/view/main_view.dart';
import 'package:yourturn_client/view/service_view.dart';

String indirizzoRoot = 'http://192.168.1.111:3000/';
const String indirizzoCoda = 'queue/';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MainController _controller = MainController();
  Widget _varWidget;
  await _controller.load();
  if(_controller.authenticate)
    _varWidget = MainView(_controller);
  else
    _varWidget = AuthenticateView(_controller);
  runApp(MaterialApp(
    routes: {
      '/authenticate': (context) => AuthenticateView(_controller),
      '/body': (context) => MainView(_controller),
      '/service': (context) => ServiceView(_controller),
    },
    home: _varWidget,
  ));
}
