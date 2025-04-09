import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Home.dart';

class QRCodeScannerSecreen extends StatefulWidget {
  const QRCodeScannerSecreen({super.key});

  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerSecreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child:
                    Icon(Icons.qr_code_scanner, size: 100, color: Colors.grey),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.circle, color: Colors.white, size: 60),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
