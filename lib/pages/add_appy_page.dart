import 'package:appy_app/pages/home_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddAppyPage extends StatefulWidget {
  const AddAppyPage({
    super.key,
  });

  @override
  State<AddAppyPage> createState() => _AddAppyPageState();
}

class _AddAppyPageState extends State<AddAppyPage> {
  bool _isDetected = false; // RFID 인식 여부

  @override
  void initState() {
    super.initState();

    // 3초 후에 이미지 표시 여부 상태 변경 (QR 찍혔다고 가정)
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isDetected = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String moduleName = "MOA TV";
    String appyName = "레비";

    return Scaffold(
      appBar: BuildSettingAppBar(context, "Appy 등록"),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 상단 "MOA TV" 제목 및 구분선
              const SizedBox(height: 20),
              Text(
                _isDetected ? appyName : "",
                style: const TextStyle(
                  color: AppColors.textMedium,
                  fontSize: TextSize.medium,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),
              Container(
                color: AppColors.buttonDisabled,
                height: _isDetected ? 1 : 0,
              ),

              // Expanded로 나머지 공간 처리
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isDetected)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //인식된 Appy 이미지 나타나기
                            Image.asset(
                              "assets/images/appy_levi.png",
                              height: 300,
                            ),
                            const Text(
                              "Appy가 등록되었습니다!",
                              style: TextStyle(
                                color: AppColors.textHigh,
                                fontSize: TextSize.medium,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        )
                      else
                        const Expanded(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // 세로 가운데 정렬
                            children: [
                              //Spinkit + '이미지별 이름' (ex: SpinkitRing , SpinkitWave 등등)
                              SpinKitChasingDots(
                                // 색상을 파란색으로 설정
                                color: AppColors.accent,
                                // 크기를 50.0으로 설정
                                size: 50.0,
                                // 애니메이션 수행 시간을 2초로 설정
                                duration: Duration(seconds: 2),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Appy를 찾는 중입니다...",
                                style: TextStyle(
                                  color: AppColors.textHigh,
                                  fontSize: TextSize.medium,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      const SizedBox(height: 30), // 메시지 아래 여백
                    ],
                  ),
                ),
              ),

              // 하단 고정된 버튼
              _isDetected
                  ? GestureDetector(
                      onTap: () {
                        // _isDetected가 true일 때만 작동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: BuildButton(
                          "홈화면으로 이동하기",
                          AppColors.accent, // 활성화 색상 (_isDetected가 true일 때)
                          AppColors.textWhite),
                    )
                  : const SizedBox(
                      height: 50,
                    ),

              // 하단 버튼 아래 여백
              const SizedBox(height: 130),
            ],
          ),
        ),
      ),
    );
  }
}
