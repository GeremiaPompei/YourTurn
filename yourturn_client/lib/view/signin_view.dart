import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

import '../main.dart';
import 'cell_view.dart';
import '../utility/errmessagesmanager.dart';

class SignInView extends StatefulWidget {
  MainController _controller;

  SignInView(this._controller);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String _nome = '';
  String _cognome = '';
  String _telefono = '';
  bool _validateNumber = true;
  String _email = '';
  String _password = '';
  String _ripetiPassword = '';
  int _vAnnoN = 0;
  List<String> _lAnnoN =
      List.generate(150, (index) => (DateTime.now().year - index).toString());
  int _vSesso = 0;
  List<String> _lSesso = ['Maschio', 'Femmina', 'Altro'];
  ErrMessagesManager _errMexM = ErrMessagesManager.fromList([
    'nome',
    'cognome',
    'telefono',
    'email',
    'password',
    'password nuovamente',
    'general',
  ]);
  int _indexButton = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colore.back2,
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  CellView(
                    'Nome',
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Inserisci il Nome',
                        errorText: _errMexM.allMex['nome'],
                      ),
                      onChanged: (text) => setState(() {
                        _nome = text;
                      }),
                    ),
                  ),
                  CellView(
                    'Cognome',
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Inserisci il Cognome',
                          errorText: _errMexM.allMex['cognome']),
                      onChanged: (text) => setState(() {
                        _cognome = text;
                      }),
                    ),
                  ),
                  CellView(
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
                  CellView(
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
                  CellView(
                    'Telefono',
                    InternationalPhoneNumberInput(
                      initialValue: PhoneNumber(isoCode: 'IT'),
                      onInputChanged: (number) =>
                          this._telefono = number.toString(),
                      onInputValidated: (value) => _validateNumber = true,
                    ),
                  ),
                  Text(
                    _errMexM.allMex['telefono'] == null
                        ? ''
                        : _errMexM.allMex['telefono'],
                    style: StileText.error,
                  ),
                  CellView(
                    'Email',
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Inserisci l\'Email',
                        errorText: _errMexM.allMex['email'],
                      ),
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
                        errorText: _errMexM.allMex['password'],
                      ),
                      obscureText: true,
                      onChanged: (text) => setState(() {
                        _password = text;
                      }),
                    ),
                  ),
                  CellView(
                    'Ripeti Password',
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Inserisci di nuovo la Password',
                        errorText: _errMexM.allMex['password nuovamente'],
                      ),
                      obscureText: true,
                      onChanged: (text) => setState(() {
                        _ripetiPassword = text;
                      }),
                    ),
                  ),
                  FlatButton(
                    color: Colore.back1,
                    child: _indexButton == 0
                        ? Text(
                            'SignIn',
                            style: StileText.sottotitolo,
                          )
                        : LinearProgressIndicator(
                            backgroundColor: Colore.front1,
                          ),
                    onPressed: () async {
                      if (_indexButton == 0) {
                        setState(() {
                          _indexButton = 1;
                          if (_nome.isNotEmpty &&
                              _cognome.isNotEmpty &&
                              _email.isNotEmpty &&
                              _telefono.isNotEmpty &&
                              _password.isNotEmpty &&
                              _ripetiPassword.isNotEmpty &&
                              _validateNumber) {
                            if (_password == _ripetiPassword) {
                              try {
                                widget._controller
                                    .signInEmailPassword(
                                        _nome,
                                        _cognome,
                                        _lAnnoN[_vAnnoN],
                                        _lSesso[_vSesso],
                                        _email,
                                        _telefono,
                                        _password)
                                    .then((value) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      '/body', (route) => route.popped == null);
                                  _indexButton = 0;
                                }).catchError((err) => {
                                          if (err.runtimeType ==
                                              SocketException)
                                            {
                                              _errMexM.manage({
                                                'general':
                                                    'Errore di connessione al server: ' +
                                                        indirizzoRoot
                                              })
                                            }
                                          else if (err.code == 'weak-password')
                                            {
                                              setState(() {
                                                _errMexM.manage({
                                                  'password':
                                                      'Password debole, minimo 6 caratteri'
                                                });
                                              })
                                            }
                                          else if (err.code == 'invalid-email')
                                            {
                                              setState(() {
                                                _errMexM.manage({
                                                  'email': 'Email non valida'
                                                });
                                              })
                                            }
                                          else if (err.code ==
                                              'email-already-in-use')
                                            {
                                              setState(() {
                                                _errMexM.manage({
                                                  'email': 'Email gia esistente'
                                                });
                                              })
                                            }
                                          else
                                            {
                                              _errMexM
                                                  .manage({'general': 'Error'})
                                            },
                                          _indexButton = 0
                                        });
                              } catch (e) {
                                _errMexM.manage({'general': 'Error'});
                                _indexButton = 0;
                              }
                            } else {
                              setState(() {
                                _errMexM.manage({
                                  'password nuovamente': 'Password differenti'
                                });
                              });
                              _indexButton = 0;
                            }
                          } else if (_nome.isEmpty ||
                              _cognome.isEmpty ||
                              _email.isEmpty ||
                              _telefono.isEmpty ||
                              _password.isEmpty ||
                              _ripetiPassword.isEmpty) {
                            _errMexM.checkEmpty({
                              'nome': _nome,
                              'cognome': _cognome,
                              'telefono': _telefono,
                              'email': _email,
                              'password': _password,
                              'password nuovamente': _ripetiPassword,
                            });
                            _indexButton = 0;
                          } else {
                            _errMexM.manage(
                                {'telefono': 'Numero di telefono non valido'});
                            _indexButton = 0;
                          }
                        });
                      }
                    },
                  ),
                  Text(
                    'Per registrarsi con Google o Facebook basta completare solamente i campi Anno di Nascita, Sesso e Telefono',
                    style: StileText.corpo,
                  ),
                  FlatButton(
                    color: Colors.red,
                    child: _indexButton == 0
                        ? Text(
                            'Google',
                            style: StileText.sottotitoloWhite,
                          )
                        : LinearProgressIndicator(
                            backgroundColor: Colore.front1,
                          ),
                    onPressed: () async {
                      if (_indexButton == 0) {
                        setState(() {
                          _indexButton = 1;
                          if (_telefono.isNotEmpty && _validateNumber) {
                            try {
                              widget._controller
                                  .googleSignIn(_lAnnoN[_vAnnoN],
                                      _lSesso[_vSesso], _telefono)
                                  .then((value) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/body', (route) => route.popped == null);
                                _indexButton = 0;
                              }).catchError((err) {
                                try {
                                  if (err.code ==
                                      'account-exists-with-different-credential') {
                                    setState(() {
                                      _errMexM.manage(
                                          {'general': 'Email gia utilizzata'});
                                      _indexButton = 0;
                                    });
                                  }
                                } catch (e) {
                                  setState(() {
                                    _errMexM.manage({'general': 'Error'});
                                    _indexButton = 0;
                                  });
                                }
                              });
                            } catch (e) {
                              _errMexM.manage({'general': 'Error'});
                              _indexButton = 0;
                            }
                          } else if (_telefono.isEmpty) {
                            _errMexM.checkEmpty({
                              'telefono': _telefono,
                            });
                            _indexButton = 0;
                          } else {
                            _errMexM.manage(
                                {'telefono': 'Numero di telefono non valido'});
                            _indexButton = 0;
                          }
                        });
                      }
                    },
                  ),
                  FlatButton(
                    color: Colors.blueAccent,
                    child: _indexButton == 0
                        ? Text(
                            'Facebook',
                            style: StileText.sottotitoloWhite,
                          )
                        : LinearProgressIndicator(
                            backgroundColor: Colore.front1,
                          ),
                    onPressed: () async {
                      if (_indexButton == 0) {
                        setState(() {
                          _indexButton = 1;
                          if (_telefono.isNotEmpty && _validateNumber) {
                            try {
                              widget._controller
                                  .facebookSignIn(_lAnnoN[_vAnnoN],
                                      _lSesso[_vSesso], _telefono)
                                  .then((value) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/body', (route) => route.popped == null);
                                _indexButton = 0;
                              }).catchError((err) {
                                try {
                                  if (err.code ==
                                      'account-exists-with-different-credential') {
                                    setState(() {
                                      _errMexM.manage(
                                          {'general': 'Email gia utilizzata'});
                                      _indexButton = 0;
                                    });
                                  }
                                } catch (e) {
                                  setState(() {
                                    _errMexM.manage({'general': 'Error'});
                                    _indexButton = 0;
                                  });
                                }
                              });
                            } catch (e) {
                              _indexButton = 0;
                            }
                          } else if (_telefono.isEmpty) {
                            _errMexM.checkEmpty({
                              'telefono': _telefono,
                            });
                            _indexButton = 0;
                          } else {
                            _errMexM.manage(
                                {'telefono': 'Numero di telefono non valido'});
                            _indexButton = 0;
                          }
                        });
                      }
                    },
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
