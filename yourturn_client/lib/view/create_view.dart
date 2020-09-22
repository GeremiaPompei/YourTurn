import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/create_cell_view.dart';

class CreateView extends StatefulWidget {
  @override
  _CreateViewState createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  var _nuovaCoda = {
    'ID': 'null',
    'Luogo': null,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colore.back2,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _nuovaCoda.length,
                itemBuilder: (context, i) =>
                    CreateCellView(_nuovaCoda, _nuovaCoda.keys.toList()[i]),
                separatorBuilder: (context, i) =>
                    SizedBox(
                      height: 20,
                    ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            QrImage(
              size: 200,
              data: _nuovaCoda['ID'],
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colore.back1,
              child: Text(
                'Create',
                style: StileText.sottotitolo,
              ),
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
