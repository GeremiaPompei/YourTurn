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
import 'buttonback_view.dart';

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

  void showPartecipa({String txt}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SearchQueueView(
              widget._controller,
              txt: txt,
            ),
            actions: [
              ButtonBackView(),
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
            showPartecipa(txt: qrCodeResult);
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
            showPartecipa();
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
