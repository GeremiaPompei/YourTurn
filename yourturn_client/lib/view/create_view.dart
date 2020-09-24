import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/icona.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/create_cell_view.dart';
import 'package:yourturn_client/view/navigation_bar.dart';
import 'package:yourturn_client/view/queuelist_view.dart';

class CreateView extends StatefulWidget {
  MainController _controller;

  CreateView(this._controller);

  @override
  _CreateViewState createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  String _id = '';
  String _luogo = '';
  String _idError = null;
  String _luogoError = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colore.back2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Flexible(
                child: QueueListView(widget._controller.myQueues),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colore.back1,
        child: IconButton(
          color: Colore.back1,
          icon: Icon(
            Icona.seconda,
            color: Colore.front1,
          ),
          onPressed: () {
            setState(() {
              showDialog(
                  context: context,
                  builder: (context) {
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
                                    CreateCellView(
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
                                    CreateCellView(
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
                              //if (_id.isNotEmpty || _luogo.isNotEmpty) {
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          child: QrImage(
                                            size: MediaQuery.of(context)
                                                .size
                                                .width,
                                            data: _id,
                                          ),
                                        ),
                                      );
                                    });
                              /*} else {
                                if (_id.isEmpty)
                                  _idError = 'Inserire Id';
                                else
                                  _idError = null;
                                if (_luogo.isEmpty)
                                  _luogoError = 'Inserire Luogo';
                                else
                                  _luogoError = null;
                              }*/
                            });
                          },
                        ),
                      ],
                    );
                  });
            });
          },
        ),
      ),
    );
  }
}
