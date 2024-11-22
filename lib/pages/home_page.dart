import 'package:appy_app/pages/appy_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildHomeAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  
                  // 페이지 이동
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AppyPage()));
                },
                child: Image.asset(
                  "assets/images/appy_levi.png",
                  width: 100,
                  ),
              )

            ]
          )
        )
      )
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
          Navigator.pop(context); //이전 페이지로 돌아가기
        },
        icon: const Icon(
          Icons.map,
          size: IconSize.medium,
          color: AppColors.icon,
          )
      ),
      actions: [
        IconButton(onPressed: 
        () {},
        icon: const Icon(
          Icons.settings,
          size: IconSize.medium,
          color: AppColors.icon,
          )
        )
      ],
    );
  }