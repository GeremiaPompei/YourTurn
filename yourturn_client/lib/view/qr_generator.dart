import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yourturn_client/main.dart';

class QRGenerator extends StatefulWidget {
  String _id;

  QRGenerator(this._id);

  @override
  _QRGeneratorState createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  @override
  Widget build(BuildContext context) {
    return QrImage(
      size: MediaQuery.of(context).size.width,
      data: indirizzoCoda + widget._id,
    );
  }
}
