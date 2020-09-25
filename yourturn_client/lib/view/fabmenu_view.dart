import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart' as speed;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/qr_scanner.dart';
import 'package:yourturn_client/view/searchqueue_view.dart';

import '../main.dart';

class FABMenuView extends StatefulWidget {
  MainController _controller;

  FABMenuView(this._controller);

  @override
  _FABMenuViewState createState() => _FABMenuViewState();
}

class _FABMenuViewState extends State<FABMenuView>
    with TickerProviderStateMixin {
  String qrCodeResult = "";
  ScrollController scrollController;
  bool dialVisible = true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          dialVisible = scrollController.position.userScrollDirection ==
              ScrollDirection.forward;
        });
      });
  }

  void showPartecipa(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(text),
            actions: [
              FlatButton(
                child: Text(
                  'Partecipa',
                  style: StileText.corpo,
                ),
                onPressed: () async {
                  Queue res = await widget._controller.getQueue(text);
                  await widget._controller.enqueueToOther(res);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return speed.SpeedDial(
      foregroundColor: Colore.front1,
      backgroundColor: Colore.back1,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        speed.SpeedDialChild(
          child: IconButton(
            icon: Icon(Icons.camera_alt, color: Colore.front1),
          ),
          onTap: () async {
            String codeSanner = await QRScanner().scan(); //barcode scnner
            setState(() {
              qrCodeResult = codeSanner;
            });
            showPartecipa(context, qrCodeResult);
          },
          backgroundColor: Colore.back1,
          label: 'Scanner',
          labelStyle: StileText.sottotitolo,
          labelBackgroundColor: Colore.back1,
        ),
        speed.SpeedDialChild(
          child: Icon(Icons.search, color: Colore.front1),
          backgroundColor: Colore.back1,
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  String text = '';
                  return AlertDialog(
                      title: SearchQueueView(
                          text,
                          widget._controller.enqueueToOther,
                          widget._controller.getQueue,
                          widget._controller.checkQueue));
                });
          },
          label: 'Cerca',
          labelStyle: StileText.sottotitolo,
          labelBackgroundColor: Colore.back1,
        ),
      ],
    );
    ;
  }
}
