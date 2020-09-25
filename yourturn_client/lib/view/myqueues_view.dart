import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/icona.dart';
import 'package:yourturn_client/view/createqueue_view.dart';
import 'package:yourturn_client/view/queuelist_view.dart';

import '../main.dart';

class MyQueuesView extends StatefulWidget {
  MainController _controller;

  MyQueuesView(this._controller);

  @override
  _MyQueuesViewState createState() => _MyQueuesViewState();
}

class _MyQueuesViewState extends State<MyQueuesView> {
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
                child: QueueListView(widget._controller.myQueues),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colore.back1,
        child: IconButton(
          color: Colore.back1,
          icon: Icon(
            Icona.seconda,
            color: Colore.front1,
          ),
          onPressed: () {
            setState(() {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: CreateQueueView(widget._controller));
                  });
            });
          },
        ),
      ),
    );
  }
}
