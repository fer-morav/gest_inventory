import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gest_inventory/utils/strings.dart';

class ScanUtil {

  static Future<List<String>> startBarcodeScanStream() async {
    List<String> barcodeScanRes = [];
    await FlutterBarcodeScanner.getBarcodeStreamReceiver(
      '#ff00446b',
      button_cancel,
      true,
      ScanMode.BARCODE,
    )!.listen(
      (barcode) => barcodeScanRes.add(barcode),
    );

    return barcodeScanRes;
  }

  static Future<String> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff00446b',
        button_cancel,
        true,
        ScanMode.QR,
      );
    } on PlatformException {
      barcodeScanRes = alert_title_error_general;
    }

    return barcodeScanRes;
  }

  static Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff00446b',
        button_cancel,
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      barcodeScanRes = alert_title_error_general;
    }

    return barcodeScanRes;
  }
}