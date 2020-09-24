import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

class QueueListView extends StatefulWidget {
  List<Queue> _queues;

  QueueListView(this._queues);

  @override
  _QueueListViewState createState() => _QueueListViewState();
}

class _QueueListViewState extends State<QueueListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, i) => ListTile(
        onTap: () {
          setState(() {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      widget._queues[i].id,
                      style: StileText.corpo,
                    ),
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: QrImage(
                        size: MediaQuery.of(context).size.width,
                        data: widget._queues[i].id,
                      ),
                    ),
                  );
                });
          });
        },
        leading: Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            color: Colore.back1,
            shape: BoxShape.circle,
          ),
          child: Text(
            widget._queues[i].queue.length.toString(),
            style: StileText.sottotitolo,
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget._queues[i].id.toString(),
              style: StileText.sottotitolo,
            ),
            Text(
              'luogo: ' + widget._queues[i].luogo.toString(),
              style: StileText.corpoMini1,
            ),
            Text(
              'data inizio: ' +
                  DateFormat('yyyy:MM:dd')
                      .format(widget._queues[i].startDateTime),
              style: StileText.corpoMini2,
            ),
          ],
        ),
        trailing: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            DateFormat('HH:mm').format(widget._queues[i].startDateTime),
            style: StileText.corpoMini2,
          ),
        ),
      ),
      separatorBuilder: (context, i) => Divider(),
      itemCount: widget._queues.length,
    );
  }
}
