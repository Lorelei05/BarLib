import 'dart:io';

import 'package:app_bar_lib/screens/menu_screen.dart'; // Ajusta la ruta según tu estructura
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Para solicitar permisos
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear QR'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        // Extraemos el número de mesa y piso
        String code = scanData.code!;
        List<String> parts = code.split('_');
        if (parts.length == 4 && parts[0] == 'mesa' && parts[2] == 'piso') {
          String mesa = parts[1];
          String piso = parts[3];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuScreen(mesa: mesa, piso: piso),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
