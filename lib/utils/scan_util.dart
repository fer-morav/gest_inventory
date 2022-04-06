import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gest_inventory/utils/strings.dart';

class ScanUtil {

  Future<List<String>> startBarcodeScanStream() async {
    List<String> barcodeScanRes = [];
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff00446b', button_cancel, true, ScanMode.BARCODE)!
        .listen((barcode) => barcodeScanRes.add(barcode));

    return barcodeScanRes;
  }

  Future<String> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff00446b', button_cancel, true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Ha ocurrido un error';
    }

    return barcodeScanRes;
  }

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff00446b', button_cancel, true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Ha ocurrido un error';
    }

    return barcodeScanRes;
  }
}