import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

import 'create_cell_view.dart';

class LogInView extends StatefulWidget {
  MainController _controller;

  LogInView(this._controller);

  @override
  _LogInViewState createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  String _email = '';
  String _password = '';
  String _emailError = null;
  String _passwordError = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colore.back2,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  CreateCellView(
                    'Email',
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Inserisci l\'Email',
                          errorText: _emailError),
                      onChanged: (text) => setState(() {
                        _email = text;
                      }),
                    ),
                  ),
                  CreateCellView(
                    'Password',
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Inserisci la Password',
                          errorText: _passwordError),
                      obscureText: true,
                      onChanged: (text) => setState(() {
                        _password = text;
                      }),
                    ),
                  ),
                  FlatButton(
                    color: Colore.back1,
                    child: Text(
                      'LogIn',
                      style: StileText.sottotitolo,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_email.isNotEmpty || _password.isNotEmpty) {
                          widget._controller
                              .logIn(_email, _password)
                              .then((value) => {
                                    if (value != null)
                                      {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/body',
                                            (route) => route.popped == null)
                                      }
                                  })
                              .catchError((err) => {
                                    setState(() {
                                      if (err.code == 'user-not-found') {
                                        _emailError = 'Utente non trovato';
                                        _passwordError = null;
                                      } else if (err.code == 'wrong-password') {
                                        _passwordError = 'Password errata';
                                        _emailError = null;
                                      } else if (err.code == 'invalid-email') {
                                        _emailError = 'Email non valida';
                                        _passwordError = null;
                                      } else
                                        print(err);
                                    })
                                  });
                        } else {
                          setState(() {
                            if (_email.isEmpty)
                              _emailError = 'Inserire Email';
                            else
                              _emailError = null;
                            if (_password.isEmpty)
                              _passwordError = 'Inserire Password';
                            else
                              _passwordError = null;
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
