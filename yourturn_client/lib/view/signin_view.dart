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
  Map<String,String> _param = {'User': null, 'Password': null};

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
                itemCount: _param.length,
                itemBuilder: (context, i) =>
                    CreateCellView(_param, _param.keys.toList()[i]),
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
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/body', (route) => route.popped == null);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
