import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/utility/ticketnumber_converter.dart';
import './qr_generator.dart';
import './detaileduser_view.dart';
import 'package:yourturn_client/model/ticket.dart';

import '../main.dart';
import 'cell_view.dart';

class ServiceView extends StatefulWidget {
  MainController _controller;

  ServiceView(this._controller);

  @override
  _ServiceViewState createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  Ticket _ticket;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void set() {
    setState(() {
      _ticket = widget._controller.last.queue
          .where((element) =>
              element.numberCode ==
              TicketNumberConverter().fromInt(widget._controller.last.index))
          .first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colore.back2,
        elevation: 0,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        header: ClassicHeader(),
        controller: _refreshController,
        onRefresh: () => setState(() {
          widget._controller.update().then((value) {
            (context as Element).reassemble();
            _refreshController.refreshCompleted();
          });
        }),
        child: ListView(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          shrinkWrap: true,
          children: [
            CellView(
              widget._controller.last.id,
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 220,
                  height: MediaQuery.of(context).size.width - 220,
                  alignment: Alignment.center,
                  child: FlatButton(
                    child: QRGenerator(
                      widget._controller.last.id,
                    ),
                    onPressed: () {
                      final RenderBox box = context.findRenderObject();
                      Share.share(widget._controller.last.id,
                          subject: 'Your Turn [' +
                              widget._controller.last.id +
                              ']'.replaceAll(indirizzoRoot, ''),
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    },
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                TicketNumberConverter().fromInt(widget._controller.last.index),
                style: StileText.superTitolo,
              ),
            ),
            CellView(
              'Persone in coda',
              Text(
                widget._controller.last.queue.length.toString(),
                style: StileText.titolo,
              ),
            ),
            FlatButton(
              color: Colore.back1,
              child: Text(
                _ticket == null
                    ? 'Vuoto'
                    : (_ticket.user.nome + ' ' + _ticket.user.cognome),
                style: StileText.sottotitolo,
              ),
              onPressed: () {
                _ticket == null
                    ? null
                    : setState(() {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: DetailedUserView(_ticket.user),
                              );
                            });
                      });
              },
            ),
            FlatButton(
              color: Colors.green,
              child: Text('Prossimo', style: StileText.sottotitolo),
              onPressed: () async {
                if (widget._controller.last.index <=
                    widget._controller.last.queue.length) {
                  await widget._controller.next();
                  set();
                  await widget._controller.closeTicket(_ticket);
                }
              },
            ),
            FlatButton(
              color: Colors.red,
              child: Text('Termina', style: StileText.sottotitolo),
              onPressed: () async {
                await widget._controller.closeQueue();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/body', (route) => route.popped == null);
              },
            ),
          ],
        ),
      ),
    );
  }
}
