import 'package:appy_app/pages/home_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:appy_app/widgets/widget.dart';

class AddAppyPage extends StatefulWidget {
  const AddAppyPage({
    super.key,
  });

  @override
  State<AddAppyPage> createState() => _AddAppyPageState();
}

class _AddAppyPageState extends State<AddAppyPage> {
  bool _showImage = false; // 이미지 표시 여부

  @override
  void initState() {
    super.initState();

    // 2초 후에 이미지 표시 여부 상태 변경 (QR 찍혔다고 가정)
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showImage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
              const Text(
                "MOA TV",
                style: TextStyle(
                  color: AppColors.textMedium,
                  fontSize: TextSize.medium,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: AppColors.buttonDisabled,
                height: 1,
              ),

              // Expanded로 나머지 공간 처리
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_showImage)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/appy_levi.png",
                              height: 300,
                            ),
                          ],
                        )
                      else
                        Expanded(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // 세로 가운데 정렬
                            children: const [
                              
                              Text(
                                "에피를 찾는 중입니다",
                                style: TextStyle(
                                  color: AppColors.textHigh,
                                  fontSize: TextSize.medium,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 30), // 메시지 아래 여백
                    ],
                  ),
                ),
              ),

              // 하단 고정된 버튼
              GestureDetector(
                onTap: _showImage
                    ? () {
                        // _showImage가 true일 때만 작동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    : null, // 버튼 비활성화 (_showImage가 false일 때)
                child: BuildButton(
                  _showImage ?
                  "Appy 등록하러 가기" : "Appy를 찾는 중입니다...",
                  _showImage
                      ? AppColors.accent // 활성화 색상 (_showImage가 true일 때)
                      : AppColors
                          .buttonDisabled, // 비활성화 색상 (_showImage가 false일 때)
                  AppColors.textWhite,
                ),
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
