import 'package:appy_app/pages/add_appy_page.dart';
import 'package:appy_app/pages/home_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:appy_app/widgets/widget.dart';

class AddModuleAppyConnPage extends StatefulWidget {
  const AddModuleAppyConnPage({
    super.key,
  });

  @override
  State<AddModuleAppyConnPage> createState() => _AddModuleAppyConnPageState();
}

class _AddModuleAppyConnPageState extends State<AddModuleAppyConnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildSettingAppBar(context, "모듈 등록"),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // 모듈 이름 위 여백
              // 모듈 이름 받아오기
              const Text(
                "MOA TV",
                style: TextStyle(
                  color: AppColors.textMedium,
                  fontSize: TextSize.medium,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10), // 모듈 이름 아래 여백
              Container(
                color: AppColors.buttonDisabled,
                height: 1,
              ),
              // 남은 공간 활용
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //모듈에 맞는 이미지 넣기
                    Image.asset(
                      "assets/images/module_TV.png",
                      height: 200,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "모듈이 등록되었습니다!",
                      style: TextStyle(
                        color: AppColors.textHigh,
                        fontSize: TextSize.medium,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // 페이지 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddAppyPage(),
                    ),
                  );
                },
                child: BuildButton(
                  "Appy 등록하러 가기",
                  AppColors.accent,
                  AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 130), // 모듈 이름 아래 여백
            ],
          ),
        ),
      ),
    );
  }
}
