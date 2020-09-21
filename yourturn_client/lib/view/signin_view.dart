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
  Map<String, String> _params = {
    'Nome': null,
    'Cognome': null,
    'Eta': null,
    'Sesso': null,
    'Telefono': null,
    'Email': null,
    'Password': null,
    'Ripeti Password': null
  };

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
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _params.length,
                itemBuilder: (context, i) =>
                    CreateCellView(_params, _params.keys.toList()[i]),
                separatorBuilder: (context, i) => SizedBox(
                  height: 20,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colore.back1,
              child: Text(
                'SignIn',
                style: StileText.sottotitolo,
              ),
              onPressed: () {
                setState(() {
                  if (_params.values.elementAt(_params.length - 2) ==
                      _params.values.elementAt(_params.length - 1))
                    widget._controller
                        .signIn(
                            _params['Nome'],
                            _params['Cognome'],
                            _params['Eta'],
                            _params['Sesso'],
                            _params['Email'],
                            _params['Telefono'],
                            _params['Password'])
                        .then((value) {
                      if (value == 'Signed')
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/body', (route) => route.popped == null);
                    });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
