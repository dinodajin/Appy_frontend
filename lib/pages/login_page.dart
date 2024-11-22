
import 'package:appy_app/pages/add_appy_page.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // 로그인 처리 api
                  // 수정 필요
                  
                  // 페이지 이동
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddAppyPage()));
                },
                child: buildButton("로그인", AppColors.accent),
              ),

            ]
          )
        )
      )
    );
  }

}