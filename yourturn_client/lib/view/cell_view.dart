import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

class CellView extends StatefulWidget {
  String _title;
  Widget _varWidget;

  CellView(this._title, this._varWidget);

  @override
  _CellViewState createState() => _CellViewState();
}

class _CellViewState extends State<CellView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              widget._title,
              textAlign: TextAlign.center,
              style: StileText.sottotitolo,
            ),
            widget._varWidget,
          ],
        ));
  }
}
