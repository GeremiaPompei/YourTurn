import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'detailedqueue_view.dart';

class SearchQueueView extends StatefulWidget {
  String _text;
  Future<dynamic> Function(String) _get;
  Future<dynamic> Function(Queue) _enqueue;
  Future<bool> Function(String) _check;

  SearchQueueView(this._text, this._enqueue, this._get, this._check);

  @override
  _SearchQueueViewState createState() => _SearchQueueViewState();
}

class _SearchQueueViewState extends State<SearchQueueView> {
  Widget _varWidget = Container();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      color: Colore.back2,
      child: ListView(
        children: [
          Container(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Inserisci Id di una coda',
              ),
              onChanged: (input) {
                setState(
                  () {
                    widget._text = input;
                    _varWidget = CircularProgressIndicator();
                    widget._check(widget._text).then(
                          (value) => {
                            if (value)
                              {
                                setState(() {
                                  _varWidget = FloatingActionButton(
                                    backgroundColor: Colore.back2,
                                    child:
                                        Icon(Icons.done, color: Colors.green),
                                    onPressed: () async {
                                      var res = await widget._get(widget._text);
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: DetailedQueueView(res),
                                              actions: [
                                                FlatButton(
                                                  child: Text(
                                                    'Partecipa',
                                                    style: StileText.corpo,
                                                  ),
                                                  onPressed: () async {
                                                    var res = await widget
                                                        ._get(widget._text);
                                                    widget._enqueue(res);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    },
                                  );
                                })
                              }
                            else
                              {
                                setState(() {
                                  _varWidget = FloatingActionButton(
                                    backgroundColor: Colore.back2,
                                    child: Icon(Icons.close, color: Colors.red),
                                  );
                                })
                              }
                          },
                        );
                  },
                );
              },
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              color: Colore.back2,
              alignment: Alignment.center,
              child: _varWidget),
        ],
      ),
    );
  }
}
