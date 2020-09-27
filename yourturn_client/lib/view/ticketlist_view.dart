import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

import 'detailedticket_view.dart';

class TicketListView extends StatefulWidget {
  List<Ticket> _ticket;
  Future<dynamic> Function() _update;

  TicketListView(this._ticket, this._update);

  @override
  _TicketListViewState createState() => _TicketListViewState();
}

class _TicketListViewState extends State<TicketListView> {
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
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, i) => ListTile(
          onTap: () {
            setState(() {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: DetailedTicketView(widget._ticket[i]),
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
              widget._ticket[i].numberCode,
              style: StileText.sottotitolo,
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget._ticket[i].queue.id.toString(),
                style: StileText.sottotitolo,
              ),
              Text(
                'luogo: ' + widget._ticket[i].queue.luogo.toString(),
                style: StileText.corpoMini1,
              ),
              Text(
                'inizio coda: ' +
                    DateFormat('yyyy:MM:dd')
                        .format(widget._ticket[i].startQueue),
                style: StileText.corpoMini2,
              ),
            ],
          ),
          trailing: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              DateFormat('HH:mm').format(widget._ticket[i].startQueue),
              style: StileText.corpoMini2,
            ),
          ),
        ),
        separatorBuilder: (context, i) => Divider(),
        itemCount: widget._ticket.length,
      ),
    );
  }
}
