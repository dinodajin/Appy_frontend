import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({super.key});

  final MobileScannerController controller = MobileScannerController();
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildSettingAppBar(context, "QR 코드 스캐너"),
      body: Stack(
        children: [
          MobileScanner(
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
        //   Container(
        //     color: AppColors.background,
        //     height: 50,),
        ],
        ),
      
    );
  }
}
