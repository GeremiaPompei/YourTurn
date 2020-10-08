import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/utility/stile_text.dart';

class ButtonBackView extends StatefulWidget {
  @override
  _ButtonBackViewState createState() => _ButtonBackViewState();
}

class _ButtonBackViewState extends State<ButtonBackView> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: Text(
          'Indietro',
          style: StileText.corpo,
        ));
  }
}
