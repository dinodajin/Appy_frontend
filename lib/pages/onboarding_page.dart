// import 'package:appy_app/pages/home_page.dart';
import 'package:appy_app/pages/start_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _showSplash = true; // 스플래쉬 화면 표시 여부

  @override
  void initState() {
    super.initState();

    // 3초 후에 스플래쉬 화면 숨김
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기 비례로 이미지 크기 조정
    final imageWidth = (MediaQuery.of(context).size.width) * 0.7; // 화면 너비의 80%

    // 스플래쉬 화면
    if (_showSplash) {
      return Scaffold(
        backgroundColor: AppColors.primary, // 배경색
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Appy',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textHigh,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                width: imageWidth,
                'assets/images/splash_logo.png', // 로고 이미지 경로
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      );
    }

    // 온보딩 화면
    return IntroductionScreen(
      globalBackgroundColor: AppColors.primary,
      pages: [
        createPageViewModel(
          context,
          title: '모듈과 Appy를 등록하세요\n',
          iconPath: 'assets/images/onboarding_1.png',
          bodyImagePath: 'assets/images/onboarding_body_1.png',
          bodyHeight: 200,
        ),
        createPageViewModel(
          context,
          title: 'Appy와 대화하며\n일기장을 수집해보세요',
          iconPath: 'assets/images/onboarding_2.png',
          bodyImagePath: 'assets/images/onboarding_body_2.png',
          bodyHeight: 230,
        ),
        createPageViewModel(
          context,
          title: '더 다양한 Appy와 모듈을 모아\n세계관을 확장해보세요',
          iconPath: 'assets/images/onboarding_3.png',
          bodyImagePath: 'assets/images/onboarding_body_3.png',
          bodyHeight: 180
        ),
      ],
      onDone: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
        );
      },
      onSkip: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
        );
      },
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0), // 선택되지 않은 점 크기
        color: AppColors.grey200, // 선택되지 않은 점 색상
        activeSize: const Size(16.0, 10.0), // 선택된 점 크기
        activeColor: AppColors.accent, // 선택된 점 색상
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // 선택된 점 모양
        ),
      ),
      showSkipButton: true,
      skip: const Text("건너뛰기", style: TextStyle(color: AppColors.textLight)),
      next: const Icon(Icons.arrow_forward, color: AppColors.textLight),
      done: const Text("시작하기",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
    );
  }

  /// 공통 PageViewModel 생성 함수
  PageViewModel createPageViewModel(
    BuildContext context, {
    required String title,
    required String iconPath,
    required String bodyImagePath,
    required double bodyHeight,
  }) {
    return PageViewModel(
      titleWidget: Column(
        children: [
          const SizedBox(height: 80), // 아이콘부터 제목까지의 거리
          Image.asset(
            iconPath, // 아이콘
            width: 80,
          ),
          const SizedBox(height: 50), // 제목부터 이미지 까지의 거리
          Text(
            title, // 제목
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bodyWidget: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5, // 부모 높이의 50% 설정
        child: Center(
          child:  Image.asset(
            bodyImagePath, // 이미지
            height: bodyHeight,
            fit: BoxFit.contain,
          ),
        ),
      ),
      decoration: const PageDecoration(),
    );
  }
}
