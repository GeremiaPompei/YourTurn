import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

import 'create_cell_view.dart';

class SignInView extends StatefulWidget {
  MainController _controller;

  SignInView(this._controller);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String _nome = null;
  String _cognome = null;
  String _telefono = null;
  String _email = null;
  String _password = null;
  String _ripetiPassword = null;
  int _vSesso = 0;
  List<String> _lSesso = List.generate(
      150, (index) => (DateTime.now().year - index).toString());
  int _vAnnoN = 0;
  List<String> _lAnnoN = ['Maschio', 'Femmina', 'Altro'];

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
                    'Nome',
                    TextField(
                      onChanged: (text) => setState(() {
                        _nome = text;
                      }),
                    ),
                  ),
                  CreateCellView(
                    'Cognome',
                    TextField(
                      onChanged: (text) => setState(() {
                        _cognome = text;
                      }),
                    ),
                  ),
                  CreateCellView(
                    'Anno di Nascita',
                    DropdownButton(
                      items: _lAnnoN
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: _lAnnoN.indexOf(e),
                              ))
                          .toList(),
                      onChanged: (value) => {
                        setState(() {
                          _vAnnoN = value;
                        })
                      },
                      value: _vAnnoN,
                    ),
                  ),
                  CreateCellView(
                    'Sesso',
                    DropdownButton(
                      items: _lSesso
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: _lSesso.indexOf(e),
                              ))
                          .toList(),
                      onChanged: (value) => {
                        setState(() {
                          _vSesso = value;
                        })
                      },
                      value: _vSesso,
                    ),
                  ),
                  CreateCellView(
                    'Telefono',
                    TextField(
                      onChanged: (text) => setState(() {
                        _telefono = text;
                      }),
                    ),
                  ),
                  CreateCellView(
                    'Email',
                    TextField(
                      onChanged: (text) => setState(() {
                        _email = text;
                      }),
                    ),
                  ),
                  CreateCellView(
                    'Password',
                    TextField(
                      obscureText: true,
                      onChanged: (text) => setState(() {
                        _password = text;
                      }),
                    ),
                  ),
                  CreateCellView(
                    'Ripeti Password',
                    TextField(
                      obscureText: true,
                      onChanged: (text) => setState(() {
                        _ripetiPassword = text;
                      }),
                    ),
                  ),
                  FlatButton(
                    color: Colore.back1,
                    child: Text(
                      'SignIn',
                      style: StileText.sottotitolo,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_password == _ripetiPassword)
                          widget._controller
                              .signIn(
                                  _nome,
                                  _cognome,
                                  _lAnnoN[_vAnnoN],
                                  _lSesso[_vSesso],
                                  _email,
                                  _telefono,
                                  _password)
                              .then((value) {
                            if (value == 'Signed')
                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/body', (route) => route.popped == null);
                          }).catchError((err) => {
                                    if (err.code == 'weak-password')
                                      print('weak-password')
                                    else if (err.code == 'email-already-in-use')
                                      print('email-already-in-use')
                                  });
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
