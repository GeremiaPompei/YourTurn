import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/utility/stile_text.dart';

import 'buttonback_view.dart';

class PushNotificationView extends StatefulWidget {
  String _title;
  String _body;

  PushNotificationView(this._title, this._body);

  @override
  _PushNotificationViewState createState() => _PushNotificationViewState();
}

class _PushNotificationViewState extends State<PushNotificationView> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget._title, style: StileText.sottotitolo),
      content: Text(widget._body, style: StileText.corpo),
      actions: [
        ButtonBackView(),
      ],
    );
    ;
  }
}
