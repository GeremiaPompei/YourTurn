import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/utility/errmessagesmanager.dart';
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
  ErrMessagesManager _errMexM = ErrMessagesManager.fromList([
    'id',
    'luogo',
  ]);
  List<Widget> _childButton = [
    Text(
      NavigationBar.titles[1],
      style: StileText.sottotitolo,
    ),
    LinearProgressIndicator(
      backgroundColor: Colore.front1,
    )
  ];
  int _indexButton = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Text(
                    NavigationBar.titles[1],
                    style: StileText.sottotitolo,
                  ),
                  CellView(
                    'Id',
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Inserisci l\'Id',
                        errorText: _errMexM.allMex['id'],
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
                        errorText: _errMexM.allMex['luogo'],
                      ),
                      onChanged: (text) => setState(() {
                        _luogo = text;
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
                        });
                        if (_id.isNotEmpty && _luogo.isNotEmpty) {
                          if (!((await widget._controller.getQueue(_id)) ==
                              null)) {
                            setState(() {
                              _errMexM.manage({
                                'id': 'Id gia esistente, inserire un altro id'
                              });
                            });
                          } else {
                            await widget._controller.createQueue(_id, _luogo);
                            Navigator.pushNamedAndRemoveUntil(context,
                                '/service', (route) => route.popped == null);
                          }
                        } else {
                          setState(() {
                            _errMexM.checkEmpty({
                              'id': _id,
                              'luogo': _luogo,
                            });
                          });
                        }
                        setState(() {
                          _indexButton = 0;
                        });
                      }
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
