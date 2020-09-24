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
  String _nome = '';
  String _cognome = '';
  String _telefono = '';
  String _nomeError = null;
  String _cognomeError = null;
  String _telefonoError = null;
  String _email = '';
  String _emailError = null;
  String _password = '';
  String _passwordError = null;
  String _ripetiPassword = '';
  String _ripetiPasswordError = null;
  int _vAnnoN = 0;
  List<String> _lAnnoN =
      List.generate(150, (index) => (DateTime.now().year - index).toString());
  int _vSesso = 0;
  List<String> _lSesso = ['Maschio', 'Femmina', 'Altro'];

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
                      decoration: InputDecoration(
                        hintText: 'Inserisci il Nome',
                        errorText: _nomeError,
                      ),
                      onChanged: (text) => setState(() {
                        _nome = text;
                      }),
                    ),
                  ),
                  CreateCellView(
                    'Cognome',
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Inserisci il Cognome',
                          errorText: _cognomeError),
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
                      decoration: InputDecoration(
                          hintText: 'Inserisci il numero di Telefono',
                          errorText: _telefonoError),
                      onChanged: (text) => setState(() {
                        _telefono = text;
                      }),
                    ),
                  ),
                  CreateCellView(
                    'Email',
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Inserisci l\'Email',
                        errorText: _emailError,
                      ),
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
                        errorText: _passwordError,
                      ),
                      obscureText: true,
                      onChanged: (text) => setState(() {
                        _password = text;
                      }),
                    ),
                  ),
                  CreateCellView(
                    'Ripeti Password',
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Inserisci di nuovo la Password',
                        errorText: _ripetiPasswordError,
                      ),
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
                        if (_nome.isNotEmpty ||
                            _cognome.isNotEmpty ||
                            _email.isNotEmpty ||
                            _telefono.isNotEmpty ||
                            _password.isNotEmpty ||
                            _ripetiPassword.isNotEmpty) {
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
                                        {
                                          setState(() {
                                            _ripetiPasswordError = null;
                                            _emailError = null;
                                            _passwordError =
                                                'Password debole, minimo 6 caratteri';
                                          })
                                        }
                                      else if (err.code == 'invalid-email')
                                        {
                                          setState(() {
                                            _ripetiPasswordError = null;
                                            _emailError = 'Email non valida';
                                            _passwordError = null;
                                          })
                                        }
                                      else if (err.code ==
                                          'email-already-in-use')
                                        {
                                          setState(() {
                                            _ripetiPasswordError = null;
                                            _emailError = 'Email gia esistente';
                                            _passwordError = null;
                                          })
                                        }
                                    });
                          else {
                            setState(() {
                              _ripetiPasswordError = 'Password differenti';
                              _emailError = null;
                              _passwordError = null;
                            });
                          }
                        } else {
                          if (_nome.isEmpty)
                            _nomeError = 'Inserisci Nome';
                          else
                            _nomeError = null;
                          if (_cognome.isEmpty)
                            _cognomeError = 'Inserisci Cognome';
                          else
                            _cognomeError = null;
                          if (_telefono.isEmpty)
                            _telefonoError = 'Inserisci Numero di Telefono';
                          else
                            _telefonoError = null;
                          if (_email.isEmpty)
                            _emailError = 'Inserisci Email';
                          else
                            _emailError = null;
                          if (_password.isEmpty)
                            _passwordError = 'Inserisci Password';
                          else
                            _passwordError = null;
                          if (_ripetiPassword.isEmpty)
                            _ripetiPasswordError =
                                'Inserisci di nuovo la Password';
                          else
                            _ripetiPasswordError = null;
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
