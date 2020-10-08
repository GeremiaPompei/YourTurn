import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/utility/ticketnumber_converter.dart';

import 'buttonback_view.dart';
import 'detailedqueue_view.dart';
import 'detailedticket_view.dart';

class TicketListView extends StatefulWidget {
  MainController _controller;

  TicketListView(this._controller);

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
      onRefresh: () => widget._controller.update().then((value) {
        setState(() {
          (context as Element).reassemble();
          _refreshController.refreshCompleted();
        });
      }),
      child: ListView.separated(
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          i = widget._controller.tickets.length - 1 - i;
          return ListTile(
            onTap: () {
              setState(() {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content:
                            DetailedTicketView(widget._controller.tickets[i]),
                        actions: [
                          ButtonBackView(),
                        ],
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
                widget._controller.tickets[i].numberCode,
                style: StileText.sottotitolo,
              ),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget._controller.tickets[i].queue.id.toString(),
                  style: StileText.sottotitolo,
                ),
                Text(
                  widget._controller.tickets[i].queue.luogo.toString(),
                  style: StileText.corpoMini1,
                ),
                Text(
                  DateFormat('yyyy:MM:dd HH:mm')
                      .format(widget._controller.tickets[i].startQueue),
                  style: StileText.corpoMini2,
                ),
              ],
            ),
            trailing: Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              child: FloatingActionButton(
                backgroundColor: widget._controller.tickets[i].queue.index ==
                        TicketNumberConverter().fromString(
                            widget._controller.tickets[i].numberCode)
                    ? Colore.allow
                    : Colore.deny,
                child: Text(
                  TicketNumberConverter()
                      .fromInt(widget._controller.tickets[i].queue.index),
                  style: StileText.sottotitoloWhite,
                ),
                onPressed: () {
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: DetailedQueueView(
                                widget._controller.tickets[i].queue),
                            actions: [
                              ButtonBackView(),
                            ],
                          );
                        });
                  });
                },
              ),
            ),
          );
        },
        separatorBuilder: (context, i) => Divider(),
        itemCount: widget._controller.tickets.length,
      ),
    );
  }
}
