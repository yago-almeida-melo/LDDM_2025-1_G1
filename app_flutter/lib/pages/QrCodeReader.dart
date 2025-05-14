import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:io';

import 'package:app_flutter/pages/Home.dart';

class QRCodeScannerSecreen extends StatefulWidget {
  const QRCodeScannerSecreen({super.key});

  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerSecreen> {
  String _resultado = '';
  bool _lendoQRCode = true;

  void _onDetect(BarcodeCapture barcode) {
    final code = barcode.barcodes.first.rawValue;
    if (code != null && _lendoQRCode) {
      setState(() {
        _resultado = 'QR Code: $code';
        _lendoQRCode = false;
      });
    }
  }

  String? extrairNomeMedicamento(String texto) {
    final linhas = texto.split('\n');
    for (var linha in linhas) {
      if (linha.trim().length < 3) continue;

      final palavras = linha.trim().split(' ');
      final emMaiusculas = palavras.where((p) => p.length > 2 && p == p.toUpperCase());
      if (emMaiusculas.isNotEmpty) {
        return emMaiusculas.first;
      }
    }
    return null;
  }

  Future<void> _pickImageAndRecognizeText() async {
  final picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    final inputImage = InputImage.fromFile(File(pickedFile.path));
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    final textoExtraido = recognizedText.text;
    final nomeMedicamento = extrairNomeMedicamento(textoExtraido);

    setState(() {
      _resultado = nomeMedicamento != null
          ? 'Medicamento detectado: $nomeMedicamento'
          : 'Não foi possível identificar o nome do medicamento.';
      _lendoQRCode = false;
    });

    textRecognizer.close();
  }
}


  void _reset() {
    setState(() {
      _resultado = '';
      _lendoQRCode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leitor de Bula'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          },
        ),
      ),
      body: Column(
        children: [
          // Scanner QR Code ativo só se permitido
          if (_lendoQRCode)
            Expanded(
              child: MobileScanner(
                onDetect: _onDetect,
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates,
                ),
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _resultado,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Foto da caixa do remédio
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.white),
                  onPressed: _pickImageAndRecognizeText,
                ),
                IconButton(
                  icon: const Icon(Icons.circle, color: Colors.white, size: 60),
                  onPressed: _pickImageAndRecognizeText,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _reset,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
