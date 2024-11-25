import 'package:appy_app/pages/add_appy_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({super.key});

  final MobileScannerController controller = MobileScannerController();
  bool _isNavigating = false; // 중복 감지 방지 플래그

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (BarcodeCapture capture) {
        final List<Barcode> barcodes = capture.barcodes;

        for (final barcode in barcodes) {
          if (!_isNavigating) {
            _isNavigating = true; // 플래그 설정
            print('QR 코드 감지: ${barcode.rawValue}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddAppyPage(),
              ),
            ).then((_) {
              // 페이지 이동 후 플래그 초기화
              _isNavigating = false;
            });
            break; // 여러 바코드 감지를 방지
          }
        }
      },
    );
  }
}
