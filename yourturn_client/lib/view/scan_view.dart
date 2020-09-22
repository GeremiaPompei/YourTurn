import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';

class ScanView extends StatefulWidget {
  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  String qrCodeResult = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            child: Text(qrCodeResult, style: StileText.corpo),
            onPressed: () {
              setState(() {

              });
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          FlatButton(
            padding: EdgeInsets.all(15.0),
            onPressed: () async {
              String codeSanner = await BarcodeScanner.scan();    //barcode scnner
              setState(() {
                qrCodeResult = codeSanner;
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
          )
        ],
      ),
    );
  }
}
