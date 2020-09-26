import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'cell_view.dart';
import 'detailedqueue_view.dart';

class SearchQueueView extends StatefulWidget {
  MainController _controller;
  TextEditingController _txtController = TextEditingController();

  SearchQueueView(this._controller, {String txt}) {
    {
      _txtController.text = txt;
    }
  }

  @override
  _SearchQueueViewState createState() => _SearchQueueViewState();
}

class _SearchQueueViewState extends State<SearchQueueView> {
  Widget _varWidget;
  String _text = '';

  @override
  void initState() {
    _futureWidget(widget._txtController.text);
  }

  void _futureWidget(String input) {
    setState(
      () {
        _text = input;
        _varWidget = CircularProgressIndicator();
        widget._controller.checkQueue(_text).then(
              (value) => {
                if (value)
                  {
                    setState(() {
                      _varWidget = FloatingActionButton(
                        backgroundColor: Colore.back1,
                        child: Icon(Icons.done, color: Colore.front1),
                        onPressed: () async {
                          Queue queue =
                              await widget._controller.getQueue(_text);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: DetailedQueueView(queue),
                                  actions: [
                                    FlatButton(
                                      child: Text(
                                        'Partecipa',
                                        style: StileText.corpo,
                                      ),
                                      onPressed: () async {
                                        await widget._controller
                                            .enqueueToOther(queue);
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
                        backgroundColor: Colore.back1,
                        child: Icon(Icons.close, color: Colore.front1),
                      );
                    })
                  }
              },
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      color: Colore.back2,
      child: ListView(
        children: [
          Container(
            child: CellView(
              'Cerca',
              TextField(
                controller: widget._txtController,
                decoration: InputDecoration(
                  hintText: 'Inserisci Id di una coda',
                ),
                onChanged: (input) {
                  _futureWidget(input);
                },
              ),
            ),
          ),
          Container(
            height: 15,
          ),
          Container(alignment: Alignment.center, child: _varWidget),
        ],
      ),
    );
  }
}
