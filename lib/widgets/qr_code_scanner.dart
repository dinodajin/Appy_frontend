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
    const scanBoxSize = 230.0;

    return Scaffold(
      appBar: BuildSettingAppBar(context, "모듈 등록"),
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

          // 스캔 배경
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: QRScannerOverlayPainter(
              overlayColor: AppColors.background.withOpacity(0.8),
              scanBoxSize: scanBoxSize,
            ),
          ),
          // 스캔 정사각형 표시
          Center(
            child: Container(
              width: scanBoxSize,
              height: scanBoxSize,
              decoration: BoxDecoration(
                border: Border.all(color:AppColors.background, width: 2.5),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height - scanBoxSize) / 3,
              ),
              Center(
                child: Text("모듈의 QR코드를 스캔해주세요",
                    style: TextStyle(
                      color: AppColors.textHigh,
                      fontSize: TextSize.medium,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QRScannerOverlayPainter extends CustomPainter {
  final Color overlayColor;
  final double scanBoxSize;

  QRScannerOverlayPainter({
    required this.overlayColor,
    required this.scanBoxSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = overlayColor;

    // 화면 전체
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);

    // 스캔 영역 정사각형
    final scanBoxLeft = (size.width - scanBoxSize) / 2;
    final scanBoxTop = (size.height - scanBoxSize) / 2;
    final scanBoxRect = Rect.fromLTWH(
      scanBoxLeft,
      scanBoxTop,
      scanBoxSize,
      scanBoxSize,
    );

    // 스캔 영역 제외 나머지 채우기
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(fullRect),
        Path()..addRect(scanBoxRect),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
