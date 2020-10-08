import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/main.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/utility/errmessagesmanager.dart';

import 'cell_view.dart';

class RemoveUserView extends StatefulWidget {
  MainController _controller;

  RemoveUserView(this._controller);

  @override
  _RemoveUserViewState createState() => _RemoveUserViewState();
}

class _RemoveUserViewState extends State<RemoveUserView> {
  String _email = '';
  String _password = '';
  List<Widget> _childButton = [
    Text(
      'Rimuovi Utente',
      style: StileText.sottotitoloWhite,
    ),
    LinearProgressIndicator(
      backgroundColor: Colore.front1,
    )
  ];
  int _indexButton = 0;
  ErrMessagesManager _errMexM = ErrMessagesManager.fromList([
    'email',
    'password',
    'general',
  ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colore.back2,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    color: Colore.back1,
                    child: ListTile(
                      title: Text(
                        'Non possono essere utilizzati tali caratteri: ',
                        style: StileText.corpo,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        widget._controller.blacklistChars.toString(),
                        style: StileText.sottotitolo,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  CellView(
                    'Email',
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Inserisci l\'Email',
                          errorText: _errMexM.allMex['email']),
                      onChanged: (text) => setState(() {
                        _email = text;
                      }),
                    ),
                  ),
                  CellView(
                    'Password',
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Inserisci la Password',
                          errorText: _errMexM.allMex['password']),
                      obscureText: true,
                      onChanged: (text) => setState(() {
                        _password = text;
                      }),
                    ),
                  ),
                  FlatButton(
                    color: Colore.back1,
                    child: _childButton[_indexButton],
                    onPressed: () async {
                      if (_indexButton == 0) {
                        setState(() {
                          _indexButton = 1;
                          if (_email.isNotEmpty &&
                              _password.isNotEmpty &&
                              _email == widget._controller.user.email) {
                            widget._controller
                                .removeUserEmailPassword(_email, _password)
                                .then((value) => {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/authenticate',
                                          (route) => route.popped == null),
                                      _indexButton = 0
                                    })
                                .catchError((err) => {
                                      setState(() {
                                        try {
                                          if (err.code == 'user-not-found') {
                                            _errMexM.manage({
                                              'email': 'Utente non trovato'
                                            });
                                          } else if (err.code ==
                                              'wrong-password') {
                                            _errMexM.manage({
                                              'password': 'Password errata'
                                            });
                                          } else if (err.code ==
                                              'invalid-email') {
                                            _errMexM.manage(
                                                {'email': 'Email non valida'});
                                          } else {
                                            _errMexM
                                                .manage({'general': 'Errore'});
                                          }
                                        } catch (e) {
                                          if (err.runtimeType ==
                                              SocketException) {
                                            _errMexM.manage({
                                              'general':
                                                  'Errore di connessione al server: ' +
                                                      indirizzoRoot
                                            });
                                          } else {
                                            _errMexM
                                                .manage({'general': 'Errore'});
                                          }
                                        }
                                        _indexButton = 0;
                                      }),
                                    });
                          } else if (_email != widget._controller.user.email) {
                            _errMexM.manage({
                              'general':
                                  'Inserisci la stessa email del tuo profilo'
                            });
                            _indexButton = 0;
                          } else {
                            _errMexM.checkEmpty(
                                {'email': _email, 'password': _password});
                            _indexButton = 0;
                          }
                        });
                      }
                      ;
                    },
                  ),
                  FlatButton(
                    color: Colore.google,
                    child: _indexButton == 0
                        ? Text(
                            'Google',
                            style: StileText.sottotitoloWhite,
                          )
                        : LinearProgressIndicator(
                            backgroundColor: Colore.front1,
                          ),
                    onPressed: (() async {
                      if (_indexButton == 0) {
                        setState(() {
                          _indexButton = 1;
                        });
                        try {
                          await widget._controller.removeUserGoogle();
                          Navigator.pushNamedAndRemoveUntil(context,
                              '/authenticate', (route) => route.popped == null);
                          setState(() {
                            _indexButton = 0;
                          });
                        } catch (e) {
                          _errMexM.manage({'general': 'Non sei registrato'});
                          setState(() {
                            _indexButton = 0;
                          });
                        }
                      }
                    }),
                  ),
                  FlatButton(
                    color: Colore.facebook,
                    child: _indexButton == 0
                        ? Text(
                            'Facebook',
                            style: StileText.sottotitoloWhite,
                          )
                        : LinearProgressIndicator(
                            backgroundColor: Colore.front1,
                          ),
                    onPressed: (() async {
                      if (_indexButton == 0) {
                        setState(() {
                          _indexButton = 1;
                        });
                        try {
                          await widget._controller.removeUserFacebook();
                          Navigator.pushNamedAndRemoveUntil(context,
                              '/authenticate', (route) => route.popped == null);
                          setState(() {
                            _indexButton = 0;
                          });
                        } catch (e) {
                          _errMexM.manage({'general': 'Non sei registrato'});
                          setState(() {
                            _indexButton = 0;
                          });
                        }
                      }
                    }),
                  ),
                  Text(
                    _errMexM.allMex['general'] == null
                        ? ''
                        : _errMexM.allMex['general'],
                    style: StileText.error,
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
