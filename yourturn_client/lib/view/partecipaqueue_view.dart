import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

import 'detailedqueue_view.dart';

class PartecipaQueueView extends StatefulWidget {
  MainController _controller;
  Queue _queue;

  PartecipaQueueView(this._controller, this._queue);

  @override
  _PartecipaQueueViewState createState() => _PartecipaQueueViewState();
}

class _PartecipaQueueViewState extends State<PartecipaQueueView> {
  Widget _varWidget;

  @override
  void initState() {
    _varWidget = FlatButton(
      child: Text(
        'Partecipa',
        style: StileText.corpo,
      ),
      onPressed: () async {
        setState(() {
          _varWidget = CircularProgressIndicator();
        });
        await widget._controller
            .enqueueToOther(widget._queue, widget._controller.user);
        setState(() {
          _varWidget = Icon(
            Icons.done,
            color: Colore.front1,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: DetailedQueueView(widget._queue),
      actions: [
        _varWidget,
      ],
    );
  }
}
