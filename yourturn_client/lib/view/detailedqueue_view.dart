import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/utility/ticketnumber_converter.dart';
import 'package:yourturn_client/view/buttonback_view.dart';
import 'package:yourturn_client/view/qr_generator.dart';
import 'package:yourturn_client/view/detaileduser_view.dart';
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
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Container(
              alignment: Alignment.center,
              color: Colore.back1,
              child: Text(
                'CODA',
                style: StileText.titolo,
              ),
            ),
          ),
          CellView(
              'Stiamo servendo il numero',
              Text(
                TicketNumberConverter().fromInt(widget._queue.index),
                style: StileText.titolo,
              )),
          CellView(
            'Persone prima di te se partecipi ora',
            Text(
                (widget._queue.tickets.length - widget._queue.index).toString(),
                style: StileText.titolo),
          ),
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
            'Persone totali in coda',
            Text(widget._queue.tickets.length.toString(),
                style: StileText.corpo),
          ),
          widget._queue.admin == null
              ? CellView('Utente Eliminato', Container())
              : CellView(
                  'Admin',
                  FloatingActionButton(
                    backgroundColor: Colore.back1,
                    child: Icon(Icons.person, color: Colore.front1),
                    onPressed: () {
                      setState(() {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: DetailedUserView(widget._queue.admin),
                                actions: [
                                  ButtonBackView(),
                                ],
                              );
                            });
                      });
                    },
                  ),
                ),
          Container(
            height: 20,
          ),
        ],
      ),
    );
  }
}
