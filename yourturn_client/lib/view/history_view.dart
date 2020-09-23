import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

class HistoryView extends StatefulWidget {
  MainController _controller;

  HistoryView(this._controller);

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String qrCodeResult = "";

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
                    widget._controller.otherQueues[i].id,
                    style: StileText.sottotitolo,
                  ),
                  trailing: Text(
                    widget._controller.otherQueues[i].admin.nome.toString(),
                    style: StileText.sottotitolo,
                  ),
                ),
                separatorBuilder: (context, i) => Divider(),
                itemCount: widget._controller.otherQueues.length,
              ),
            ),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              onPressed: () async {
                String codeSanner =
                    await BarcodeScanner.scan(); //barcode scnner
                setState(() {
                  qrCodeResult = codeSanner;
                });
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(qrCodeResult),
                        actions: [
                          FlatButton(
                            child: Text(
                              'Partecipa',
                              style: StileText.corpo,
                            ),
                            onPressed: () async {
                              await widget._controller
                                  .enqueueToOther(qrCodeResult);
                            },
                          ),
                        ],
                      );
                    });
                // try{
                //   BarcodeScanner.scan()    this method is used to scan the QR code
                // }catch (e){
                //   BarcodeScanner.CameraAccessDenied;   we can print that user has denied for the permisions
                //   BarcodeScanner.UserCanceled;   we can print on the page that user has cancelled
                // }
              },
              child: Text(
                "Apri Scanner",
                style: StileText.corpo,
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colore.front1, width: 3.0),
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          ],
        ),
      ),
    );
  }
}
