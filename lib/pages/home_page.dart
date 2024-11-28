import 'dart:math';

import 'package:appy_app/pages/appy_page.dart';
import 'package:appy_app/pages/module_map_page.dart';
import 'package:appy_app/pages/setting_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';

//에피 모여있는 페이지
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _topAnimations = [];
  final List<Animation<double>> _leftAnimations = [];
  final Random _random = Random();
  final List<Map<String, double>> _startPositions = [
    {"top": 300, "left": 200},
    {"top": 200, "left": 150},
    {"top": 200, "left": 300},
  ];

  // 영역 제한 값 설정
  final double topMin = 200;
  final double topMax = 400;
  late double leftMin = 10;
  late double leftMax = 300;

  @override
  void initState() {
    super.initState();

    // 화면 크기에 따라 left 제한값 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      leftMin = 0;
      leftMax = screenWidth - 100; // 이미지 크기(100)만큼 빼기
    });

    for (var i = 0; i < _startPositions.length; i++) {
      // 각각의 AnimationController 생성
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );

      _controllers.add(controller);

      // 초기 애니메이션 설정
      _setNewAnimationValues(i);

      // 애니메이션 상태 변경 감지 및 반복 실행
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _setNewAnimationValues(i);
          controller.forward(from: 0); // 다시 애니메이션 시작
        }
      });

      controller.forward(); // 애니메이션 시작
    }
  }

  void _setNewAnimationValues(int index) {
    final startTop = _startPositions[index]["top"]!;
    final startLeft = _startPositions[index]["left"]!;

    // 새로운 랜덤 위치 생성 (범위 제한)
    final newTop = (startTop + _random.nextInt(40) - 20)
        .clamp(topMin, topMax); // top은 200 ~ 500 사이
    final newLeft = (startLeft + _random.nextInt(40) - 20)
        .clamp(leftMin, leftMax); // left는 0 ~ 화면의 가로 길이

    // 애니메이션 업데이트
    setState(() {
      if (_topAnimations.length > index) {
        _topAnimations[index] = Tween<double>(begin: startTop, end: newTop)
            .animate(_controllers[index]);
        _leftAnimations[index] = Tween<double>(begin: startLeft, end: newLeft)
            .animate(_controllers[index]);
      } else {
        _topAnimations.add(Tween<double>(begin: startTop, end: newTop)
            .animate(_controllers[index]));
        _leftAnimations.add(Tween<double>(begin: startLeft, end: newLeft)
            .animate(_controllers[index]));
      }

      // 새로운 시작 위치 업데이트
      _startPositions[index]["top"] = newTop;
      _startPositions[index]["left"] = newLeft;
    });
  }

  @override
  void dispose() {
    // 모든 AnimationController 해제
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: _buildHomeAppBar(context),
      body: Stack(
        children: [
          Container(
            height: 812, //아이폰 미니 높이
            child: SizedBox.expand(
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          //등록된 에피 불러와서 이미지로 모두 표시하기
          //각 이미지에 해당하는 에피 아이디 연결
          //1번째 에피
          AnimatedBuilder(
            animation: _controllers[0],
            builder: (context, child) {
              return Positioned(
                top: _topAnimations[0].value,
                left: _leftAnimations[0].value,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppyPage(
                          appyID: "ID001", appyType: 0,
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/images/appy_levi.png",
                    height: ImageSize.appySmall,
                  ),
                ),
              );
            },
          ),

          //2번째 에피
          AnimatedBuilder(
            animation: _controllers[1],
            builder: (context, child) {
              return Positioned(
                top: _topAnimations[1].value,
                left: _leftAnimations[1].value,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppyPage(
                          appyID: "ID002",
                          appyType: 1,
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/images/appy_bobby.png",
                    height: ImageSize.appySmall,
                  ),
                ),
              );
            },
          ),

          //2번째 에피
          AnimatedBuilder(
            animation: _controllers[2],
            builder: (context, child) {
              return Positioned(
                top: _topAnimations[2].value,
                left: _leftAnimations[2].value,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppyPage(
                          appyID: "ID003",
                          appyType: 2,
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/images/appy_nubi.png",
                    height: ImageSize.appySmall,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

AppBar _buildHomeAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    toolbarHeight: 70,
    centerTitle: true,
    leading: IconButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ModuleMapPage()));
        },
        icon: const Icon(
          Icons.map,
          size: IconSize.medium,
          color: AppColors.icon,
        )),
    actions: [
      IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingPage()));
          },
          icon: const Icon(
            Icons.settings,
            size: IconSize.medium,
            color: AppColors.icon,
          ))
    ],
  );
}
