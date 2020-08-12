import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';

class QRScan extends StatefulWidget {
  @override
  _QRScan createState() => _QRScan();
}

class _QRScan extends State<QRScan> {
  String contents = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Scan')),
      body: Column(children: [
        Text(contents),
        RaisedButton(
          child: Text('Scan'),
          onPressed: () async {
            var result = await BarcodeScanner.scan();
            setState(() {
              contents = result.rawContent;
            });
          },
        )
      ]),
    );
  }
}
