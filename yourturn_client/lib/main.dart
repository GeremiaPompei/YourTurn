import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/view/authenticate_view.dart';
import 'package:yourturn_client/view/main_view.dart';

void main() {
  MainController _controller = MainController();
  runApp(MaterialApp(
    routes: {
      '/authenticate': (context) => AuthenticateView(_controller),
      '/body': (context) => MainView(_controller),
    },
    home: AuthenticateView(_controller),
  ));
}
