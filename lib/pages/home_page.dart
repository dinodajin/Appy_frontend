import 'package:appy_app/pages/appy_page.dart';
import 'package:appy_app/pages/module_map_page.dart';
import 'package:appy_app/pages/setting_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';

//에피 모여있는 페이지
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(height: 300),
                GestureDetector(
                  onTap: () {
                    // 페이지 이동
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppyPage()));
                  },
                  child: Image.asset(
                    "assets/images/appy_levi.png",
                    width: 100,
                  ),
                ),
              ],
            )
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
