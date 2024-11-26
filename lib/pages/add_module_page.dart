import 'package:appy_app/pages/add_appy_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/widgets/qr_code_scanner.dart';

class AddModulePage extends StatefulWidget {
  const AddModulePage({
    super.key,
  });

  @override
  State<AddModulePage> createState() => _AddModulePageState();
}

class _AddModulePageState extends State<AddModulePage> {
  @override
  void initState() {
    super.initState();

    // 1초 후에 다음 페이지로 이동 (임시)
    // Future.delayed(const Duration(seconds: 1), () {
    //   setState(() {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => const AddAppyPage()));
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildSettingAppBar(context, "모듈 등록"),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
              ),
              const Text(
                "모듈의 QR코드를 인식해주세요",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textHigh,
                  fontSize: TextSize.medium,
                  fontWeight: FontWeight.w700,
                  
                ),
              ),
              Container(
                height: 50,
              ),
              // QR 코드 카메라 촬영 기능
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(3.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fixedSize: const Size(250, 80),
                  // 텍스트 칼라
                  foregroundColor: AppColors.textWhite,
                  // 메인 칼라
                  backgroundColor: AppColors.accent,
                  elevation: 5,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: TextSize.medium,
                    fontFamily: "SUITE",
                  ),
                ),
                child: const Text('QR코드 스캔'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QrCodeScanner(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
