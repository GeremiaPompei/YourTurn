import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/fabmenu_view.dart';
import 'package:yourturn_client/view/queuelist_view.dart';

import '../main.dart';

class OtherQueuesView extends StatefulWidget {
  MainController _controller;

  OtherQueuesView(this._controller);

  @override
  _OtherQueuesViewState createState() => _OtherQueuesViewState();
}

class _OtherQueuesViewState extends State<OtherQueuesView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colore.back2,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Flexible(
                  child: QueueListView(widget._controller.otherQueues),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FABMenuView(widget._controller));
  }
}
