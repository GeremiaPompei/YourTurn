import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/view/authenticate_view.dart';
import 'package:yourturn_client/view/main_view.dart';
import 'package:yourturn_client/view/service_view.dart';

const String indirizzoRoot = 'https://.../';
const String indirizzoCoda = 'pdfqueue/';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MainController _controller = MainController();
  runApp(MaterialApp(
    routes: {
      '/authenticate': (context) => AuthenticateView(_controller),
      '/body': (context) => MainView(_controller),
      '/service': (context) => ServiceView(_controller),
    },
    home: FutureBuilder(
      future: _controller.load(),
      builder: (context, snapshot) {
        Widget tmpWidget;
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data.queue == null) {
              tmpWidget = MainView(_controller);
            } else {
              tmpWidget = ServiceView(_controller);
            }
          } else {
            tmpWidget = AuthenticateView(_controller);
          }
        } else if (snapshot.hasError) {
          tmpWidget = AuthenticateView(_controller);
        } else {
          tmpWidget = Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colore.back2,
              elevation: 0,
            ),
            body: Container(
                color: Colore.back2,
                alignment: Alignment.center,
                child: CircularProgressIndicator()),
          );
        }
        return tmpWidget;
      },
    ),
  ));
}
