import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/create_cell_view.dart';
import 'package:yourturn_client/view/navigation_bar.dart';

class CreateView extends StatefulWidget {
  MainController _controller;

  CreateView(this._controller);

  @override
  _CreateViewState createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  String _id;
  String _luogo;

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
                    widget._controller.myQueues[i].id,
                    style: StileText.sottotitolo,
                  ),
                  trailing: Text(
                    widget._controller.myQueues[i].admin.nome.toString(),
                    style: StileText.sottotitolo,
                  ),
                ),
                separatorBuilder: (context, i) => Divider(),
                itemCount: widget._controller.myQueues.length,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colore.back1,
              child: Text(
                NavigationBar.titles[1],
                style: StileText.sottotitolo,
              ),
              onPressed: () {
                setState(() {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            NavigationBar.titles[1],
                            style: StileText.sottotitolo,
                          ),
                          content: Container(
                            height: 300,
                            width: 300,
                            color: Colore.back2,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Flex(
                                direction: Axis.vertical,
                                children: <Widget>[
                                  Flexible(
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        CreateCellView(
                                          'ID',
                                          TextField(
                                            onChanged: (text) => setState(() {
                                              _id = text;
                                            }),
                                          ),
                                        ),
                                        CreateCellView(
                                          'Luogo',
                                          TextField(
                                            onChanged: (text) => setState(() {
                                              _luogo = text;
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            FlatButton(
                              color: Colore.back1,
                              child: Text(
                                NavigationBar.titles[1],
                                style: StileText.sottotitolo,
                              ),
                              onPressed: () {
                                setState(() {
                                  widget._controller.createQueue(_id, _luogo);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(_id),
                                          content: Container(
                                            width: 100,
                                            height: 100,
                                            alignment: Alignment.center,
                                            child: QrImage(
                                              size: 100,
                                              data: _id,
                                            ),
                                          ),
                                        );
                                      });
                                });
                              },
                            ),
                          ],
                        );
                      });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
