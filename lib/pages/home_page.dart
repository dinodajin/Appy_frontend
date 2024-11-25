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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _topAnimation;
  late Animation<double> _topAnimation2;
  late Animation<double> _leftAnimation;
  late Animation<double> _leftAnimation2;

  @override
  void initState() {
    super.initState();

    // AnimationController 초기화
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    Animation<double> buildAnimation(double begin, double end) {
      return Tween<double>(begin: begin, end: end).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
    }

    // Tween으로 애니메이션 정의
    _topAnimation = buildAnimation(300, 310);
    _topAnimation2 = buildAnimation(380, 400);

    _leftAnimation = buildAnimation(150, 240);
    _leftAnimation2 = buildAnimation(200, 100);

    // 애니메이션 반복
    _controller.repeat(reverse: true);
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
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: _topAnimation.value,
                left: _leftAnimation.value,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppyPage(
                          appyID: "001",
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/images/appy_levi.png",
                    height: 100,
                  ),
                ),
              );
            },
          ),

          //2번째 에피
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: _topAnimation2.value,
                left: _leftAnimation2.value,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppyPage(
                          appyID: "002",
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/images/appy_nubi.png",
                    height: 100,
                  ),
                ),
              );
            },
          ),

          //두번째 에피
          // GestureDetector(
          //   onTap: () {
          //     // 페이지 이동
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const AppyPage(
          //                   appyID: "002",
          //                 )));
          //   },
          //   child: Image.asset(
          //     "assets/images/appy_levi.png",
          //     width: 100,
          //   ),
          // ),
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
              MaterialPageRoute(builder: (context) => ModuleMapPage()));
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
                MaterialPageRoute(builder: (context) => SettingPage()));
          },
          icon: const Icon(
            Icons.settings,
            size: IconSize.medium,
            color: AppColors.icon,
          ))
    ],
  );
}
