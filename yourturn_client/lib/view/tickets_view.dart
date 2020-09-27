import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/view/fabmenu_view.dart';
import 'package:yourturn_client/view/ticketlist_view.dart';

class TicketsView extends StatefulWidget {
  MainController _controller;

  TicketsView(this._controller);

  @override
  _TicketsViewState createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TicketListView(
            widget._controller.tickets, widget._controller.update),
        floatingActionButton: FABMenuView(widget._controller));
  }
}
