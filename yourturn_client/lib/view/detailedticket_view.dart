import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/detailedqueue_view.dart';
import 'package:yourturn_client/view/detaileduser_view.dart';
import 'cell_view.dart';

class DetailedTicketView extends StatefulWidget {
  Ticket _ticket;

  DetailedTicketView(this._ticket);

  @override
  _DetailedTicketViewState createState() => _DetailedTicketViewState();
}

class _DetailedTicketViewState extends State<DetailedTicketView> {
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
                'TICKET',
                style: StileText.titolo,
              ),
            ),
          ),
          CellView(
            'Numero',
            Text(widget._ticket.numberCode.toString(), style: StileText.titolo),
          ),
          CellView(
            'Data e Ora inizio coda',
            Text(
                DateFormat('yyyy:MM:dd HH:mm')
                    .format(widget._ticket.startQueue),
                style: StileText.corpo),
          ),
          CellView(
            'Data e Ora fine coda',
            widget._ticket.stopQueue == null
                ? Text('In corso...', style: StileText.corpo)
                : Text(
                DateFormat('yyyy:MM:dd HH:mm')
                    .format(widget._ticket.stopQueue),
                style: StileText.corpo),
          ),
          CellView(
            'Coda',
            FloatingActionButton(
              backgroundColor: Colore.back1,
              child: Icon(Icons.people, color: Colore.front1),
              onPressed: () {
                setState(() {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: DetailedQueueView(widget._ticket.queue),
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
