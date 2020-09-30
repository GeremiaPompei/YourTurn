import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/detailedqueue_view.dart';

class QueueListView extends StatefulWidget {
  List<Queue> _queues;
  Future<dynamic> Function() _update;

  QueueListView(this._queues, this._update);

  @override
  _QueueListViewState createState() => _QueueListViewState();
}

class _QueueListViewState extends State<QueueListView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      header: ClassicHeader(),
      controller: _refreshController,
      onRefresh: () => widget._update().then((value) {
        setState(() {
          (context as Element).reassemble();
        });
        _refreshController.refreshCompleted();
      }),
      child: ListView.separated(
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          i = widget._queues.length - 1 - i;
          return ListTile(
            onTap: () {
              setState(() {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: DetailedQueueView(widget._queues[i]),
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
                widget._queues[i].tickets.length.toString(),
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
          );
        },
        separatorBuilder: (context, i) => Divider(),
        itemCount: widget._queues.length,
      ),
    );
  }
}
