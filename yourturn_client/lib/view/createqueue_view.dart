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
    'general',
  ]);
  List<Widget> _childButton = [
    Text(
      NavigationBar.titles[0],
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
                  Container(
                    height: 20,
                  ),
                  Text(
                    NavigationBar.titles[0],
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
                            try {
                              await widget._controller.createQueue(_id, _luogo);
                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/service', (route) => route.popped == null);
                            } catch (e) {
                              setState(() {
                                _errMexM.manage({'general': 'Error'});
                              });
                            }
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
