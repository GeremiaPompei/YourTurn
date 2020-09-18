import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
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
                  itemBuilder: (context, i) => ListTile(
                        onTap: () {
                          setState(() {});
                        },
                        leading: Text(
                          'Numero',
                          style: StileText.sottotitolo,
                        ),
                        trailing: Text(i.toString()),
                      ),
                  separatorBuilder: (context, i) => Divider(),
                  itemCount: 30),
            ),
          ],
        ),
      ),
    );
  }
}
