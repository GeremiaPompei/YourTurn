import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/detailedticket_view.dart';

import 'buttonback_view.dart';
import 'detailedqueue_view.dart';

class PartecipaQueueView extends StatefulWidget {
  MainController _controller;
  Queue _queue;

  PartecipaQueueView(this._controller, this._queue);

  @override
  _PartecipaQueueViewState createState() => _PartecipaQueueViewState();
}

class _PartecipaQueueViewState extends State<PartecipaQueueView> {
  Widget _contentWidget;
  Widget _actionWidget;

  @override
  void initState() {
    _contentWidget = DetailedQueueView(widget._queue);
    _actionWidget = FlatButton(
      child: Text(
        'Partecipa',
        style: StileText.corpo,
      ),
      onPressed: () async {
        setState(() {
          _actionWidget = CircularProgressIndicator();
        });
        Ticket ticket = await widget._controller
            .enqueueToOther(widget._queue, widget._controller.user);
        setState(() {
          _actionWidget = Icon(
            Icons.done,
            color: Colore.front1,
          );
          _contentWidget = DetailedTicketView(ticket);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: _contentWidget,
      actions: [
        _actionWidget,
        ButtonBackView(),
      ],
    );
  }
}
