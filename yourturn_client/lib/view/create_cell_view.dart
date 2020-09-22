import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

class CreateCellView extends StatefulWidget {
  Map<String, String> _nuovaCoda;
  String _title;

  CreateCellView(this._nuovaCoda, this._title);

  @override
  _CreateCellViewState createState() => _CreateCellViewState();
}

class _CreateCellViewState extends State<CreateCellView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget._title,
          textAlign: TextAlign.center,
          style: StileText.sottotitolo,
        ),
        TextField(
          onChanged: (text) => setState(() {
            widget._nuovaCoda[widget._title] = text;
          }),
        ),
      ],
    );
  }
}
