import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/qr_generator.dart';
import 'package:yourturn_client/view/user_view.dart';
import 'cell_view.dart';

class DetailedQueueView extends StatefulWidget {
  Queue _queue;

  DetailedQueueView(this._queue);

  @override
  _DetailedQueueViewState createState() => _DetailedQueueViewState();
}

class _DetailedQueueViewState extends State<DetailedQueueView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      color: Colore.back2,
      child: ListView(
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: QRGenerator(widget._queue.id),
            ),
          ),
          CellView(
            'Id',
            Text(widget._queue.id.toString(), style: StileText.corpo),
          ),
          CellView(
            'Luogo',
            Text(widget._queue.luogo.toString(), style: StileText.corpo),
          ),
          CellView(
            'Data e Ora inizio',
            Text(
                DateFormat('yyyy:MM:dd HH:mm')
                    .format(widget._queue.startDateTime),
                style: StileText.corpo),
          ),
          CellView(
            'Data e Ora fine',
            widget._queue.stopDateTime == null
                ? Text('In corso...', style: StileText.corpo)
                : Text(
                    DateFormat('yyyy:MM:dd HH:mm')
                        .format(widget._queue.stopDateTime),
                    style: StileText.corpo),
          ),
          CellView(
            'Persone in coda',
            Text(widget._queue.queue.length.toString(), style: StileText.corpo),
          ),
          CellView(
            'Admin',
            Text(
                widget._queue.admin.nome.toString() +
                    ' ' +
                    widget._queue.admin.cognome.toString(),
                style: StileText.corpo),
          ),
          Container(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: Colore.back1,
            child: Icon(Icons.person, color: Colore.front1),
            onPressed: () {
              setState(() {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: UserView(widget._queue.admin),
                      );
                    });
              });
            },
          ),
          Container(
            height: 20,
          ),
        ],
      ),
    );
  }
}
