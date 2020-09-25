import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/qr_generator.dart';

import '../main.dart';
import 'cell_view.dart';
import 'navigation_bar.dart';

class CreateQueueView extends StatefulWidget {
  MainController _controller;

  CreateQueueView(this._controller);

  @override
  _CreateQueueViewState createState() => _CreateQueueViewState();
}

class _CreateQueueViewState extends State<CreateQueueView> {
  String _id = '';
  String _luogo = '';
  String _idError = null;
  String _luogoError = null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        NavigationBar.titles[1],
        style: StileText.sottotitolo,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
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
                    CellView(
                      'Id',
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Inserisci l\'Id',
                          errorText: _idError,
                        ),
                        onChanged: (text) => setState(() {
                          _id = text;
                        }),
                      ),
                    ),
                    CellView(
                      'Luogo',
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Inserisci il Luogo',
                          errorText: _luogoError,
                        ),
                        onChanged: (text) => setState(() {
                          _luogo = text;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        FlatButton(
          color: Colore.back1,
          child: Text(
            NavigationBar.titles[1],
            style: StileText.sottotitolo,
          ),
          onPressed: () {
            setState(() {
              if (_id.isNotEmpty && _luogo.isNotEmpty) {
                widget._controller.createQueue(_id, _luogo);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          _id,
                          style: StileText.corpo,
                        ),
                        content: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: QRGenerator(_id),
                        ),
                      );
                    });
              } else {
                if (_id.isEmpty)
                  _idError = 'Inserire Id';
                else
                  _idError = null;
                if (_luogo.isEmpty)
                  _luogoError = 'Inserire Luogo';
                else
                  _luogoError = null;
              }
            });
          },
        ),
      ],
    );
  }
}
