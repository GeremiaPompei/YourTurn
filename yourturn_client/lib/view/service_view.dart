import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/model/queue.dart';
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
  Queue _queue;
  Ticket _ticket;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Widget> _prossimoW = [
    Text('Prossimo', style: StileText.sottotitolo),
    LinearProgressIndicator(
      backgroundColor: Colore.front1,
    ),
  ];
  int _indexProssimo = 0;

  @override
  void initState() {
    this._queue = widget._controller.queue;
  }

  void set() {
    setState(() {
      _ticket = _queue.tickets
          .where((element) =>
              element.numberCode ==
              TicketNumberConverter().fromInt(_queue.index))
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
        title: Text(_queue.id, style: StileText.sottotitolo),
      ),
      body: Container(
        color: Colore.back2,
        child: SmartRefresher(
          enablePullDown: true,
          header: ClassicHeader(),
          controller: _refreshController,
          onRefresh: () => widget._controller.getQueue(_queue.id).then((value) {
            setState(() {
              _queue = value;
              _refreshController.refreshCompleted();
            });
          }),
          child: ListView(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            shrinkWrap: true,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 220,
                  height: MediaQuery.of(context).size.width - 220,
                  alignment: Alignment.center,
                  child: QRGenerator(
                    _queue.id,
                  ),
                ),
              ),
              FloatingActionButton(
                backgroundColor: Colore.back1,
                child: Icon(
                  Icons.link,
                  color: Colore.front1,
                ),
                onPressed: () async{
                  await launch(indirizzoRoot + indirizzoCoda + _queue.id);
                },
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  TicketNumberConverter().fromInt(_queue.index),
                  style: StileText.superTitolo,
                ),
              ),
              CellView(
                'Persone Rimanenti in coda',
                Text(
                  (_queue.tickets.length - _queue.index).toString(),
                  style: StileText.titolo,
                ),
              ),
              FlatButton(
                color: Colore.back1,
                child: Text(
                  _ticket == null
                      ? 'Vuoto'
                      : _ticket == null
                          ? 'Utente Eliminato'
                          : (_ticket.user.nome + ' ' + _ticket.user.cognome),
                  style: StileText.sottotitolo,
                ),
                onPressed: () {
                  if (_ticket != null && _ticket.user != null) {
                    setState(() {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: DetailedUserView(_ticket.user),
                            );
                          });
                    });
                  }
                },
              ),
              FlatButton(
                color: Colore.allow,
                child: _prossimoW[_indexProssimo],
                onPressed: () async {
                  try {
                    if (_indexProssimo == 0) {
                      setState(() {
                        _indexProssimo = 1;
                      });
                      if (_queue.index == _queue.tickets.length)
                        _queue = await widget._controller.getQueue(_queue.id);
                      if (_queue.index < _queue.tickets.length) {
                        _queue = await widget._controller.next(_queue);
                        set();
                      }
                      setState(() {
                        _indexProssimo = 0;
                      });
                    }
                  } catch (e) {
                    setState(() {
                      _indexProssimo = 0;
                    });
                  }
                },
              ),
              FlatButton(
                color: Colore.deny,
                child: Text('Termina', style: StileText.sottotitolo),
                onPressed: () {
                  widget._controller.closeQueue(_queue);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/body', (route) => route.popped == null);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
