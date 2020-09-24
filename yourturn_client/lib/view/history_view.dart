import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart' as speed;
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/queuelist_view.dart';

class HistoryView extends StatefulWidget {
  MainController _controller;

  HistoryView(this._controller);

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>
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

  speed.SpeedDial buildSpeedDial() {
    return speed.SpeedDial(
      foregroundColor: Colore.front1,
      backgroundColor: Colore.back1,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        speed.SpeedDialChild(
          child: Icon(Icons.camera_alt, color: Colore.front1),
          backgroundColor: Colore.back1,
          onTap: () async {
            String codeSanner = await BarcodeScanner.scan(); //barcode scnner
            setState(() {
              qrCodeResult = codeSanner;
            });
            showPartecipa(context, qrCodeResult);
          },
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
                    title: Text(text),
                    content: Container(
                      width: 200,
                      height: 20,
                      child: TextField(
                        onChanged: (input) {
                          text = input;
                        },
                      ),
                    ),
                    actions: [
                      FlatButton(
                        child: Text(
                          'Cerca',
                          style: StileText.corpo,
                        ),
                        onPressed: () {
                          showPartecipa(context, text);
                        },
                      ),
                    ],
                  );
                });
          },
          label: 'Cerca',
          labelStyle: StileText.sottotitolo,
          labelBackgroundColor: Colore.back1,
        ),
      ],
    );
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
                  await widget._controller.enqueueToOther(text);
                },
              ),
            ],
          );
        });
  }

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
        floatingActionButton: buildSpeedDial());
  }
}
