import 'package:barcode_scan/barcode_scan.dart';
import 'package:yourturn_client/main.dart';

class QRScanner {

  Future<String> scan() async{
    String codeSanner = await BarcodeScanner.scan();
    return codeSanner.replaceAll(indirizzoCoda, '');
  }

}
