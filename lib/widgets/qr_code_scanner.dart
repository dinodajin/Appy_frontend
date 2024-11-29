import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({super.key});

  final MobileScannerController controller = MobileScannerController();
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR 코드 스캐너")),
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;

          for (final barcode in barcodes) {
            if (!_isNavigating) {
              _isNavigating = true;
              print('QR 코드 감지: ${barcode.rawValue}');
              Navigator.pop(context, barcode.rawValue); // QR 코드 데이터를 반환
              break;
            }
          }
        },
      ),
    );
  }
}
