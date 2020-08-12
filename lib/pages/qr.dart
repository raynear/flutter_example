import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QR extends StatefulWidget {
  @override
  _QR createState() => _QR();
}

class _QR extends State<QR> {
  String contents = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR')),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                contents = value;
              });
            },
          ),
          QrImage(
            data: contents,
            version: QrVersions.auto,
            size: 200.0,
          )
        ],
      ),
    );
  }
}
