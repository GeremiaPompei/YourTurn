import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/login_view.dart';
import 'package:yourturn_client/view/signin_view.dart';

class AuthenticateView extends StatefulWidget {
  MainController _controller;

  AuthenticateView(this._controller);

  @override
  _AuthenticateViewState createState() => _AuthenticateViewState();
}

class _AuthenticateViewState extends State<AuthenticateView> {
  Widget _varWidget;

  @override
  void initState() {
    this._varWidget = LogInView(widget._controller);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colore.back1,
          title: Text(
            'Your Turn',
            style: StileText.titolo,
          ),
          bottom: TabBar(
            indicatorColor: Colore.front1,
            labelColor: Colore.front1,
            unselectedLabelColor: Colore.back2,
            tabs: [
              Tab(
                text: 'LogIn',
              ),
              Tab(
                text: 'SignIn',
              ),
            ],
            onTap: (i) => {
              setState(() {
                switch (i) {
                  case 0:
                    this._varWidget = LogInView(widget._controller);
                    break;
                  case 1:
                    this._varWidget = SignInView(widget._controller);
                    break;
                }
              })
            },
          ),
        ),
        body: _varWidget,
      ),
    );
  }
}
