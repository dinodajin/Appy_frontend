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

class _HomePageState extends State<HomePage> {
  bool _animationFlag = false;

  @override
  void initState() {
    super.initState();

    // 100ms 후에 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _animationFlag = true;
      });
    });
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
            Stack(
              children: [
                //첫번째 에피
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1000),
                  top: _animationFlag ? 300 : 320,
                  left: _animationFlag ? 200 : 100,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AppyPage(
                                    appyID: "001",
                                  )));
                    },
                    child: Image.asset(
                      "assets/images/appy_levi.png",
                      width: 100,
                    ),
                  ),
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
          ],
        ));
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
