import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

class CreateCellView extends StatefulWidget {
  String _title;
  Widget _varWidget;

  CreateCellView(this._title, this._varWidget);

  @override
  _CreateCellViewState createState() => _CreateCellViewState();
}

class _CreateCellViewState extends State<CreateCellView> {
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
