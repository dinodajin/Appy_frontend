import 'package:appy_app/pages/login_page.dart';
import 'package:appy_app/pages/signup_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';

// 처음 시작했을때 로그인, 회원가입 버튼 뜨는 창
class StartPage extends StatelessWidget {
  const StartPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.accent,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/start_background.png"),
                      fit: BoxFit.fill)),
            ),
            SafeArea(
                child: Padding(
                    padding: AppPadding.body,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Appy",
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text("에피소드를 시작해보세요",
                                    style: TextStyle(
                                      fontSize: TextSize.large,
                                      fontWeight: FontWeight.w700,
                                    ))
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // 페이지 이동
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                },
                                child: _buildStartButton("로그인",
                                    AppColors.primary, AppColors.textHigh),
                              ),
                              Container(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // 페이지 이동
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpPage()));
                                },
                                child: _buildStartButton("회원가입",
                                    AppColors.background, AppColors.textHigh),
                              ),
                            ],
                          ),
                        ]))),
          ],
        ));
  }
}

Container _buildStartButton(
    String buttonName, Color buttonColor, Color textColor) {
  return Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      color: buttonColor,
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.center,
    child: Text(
      buttonName,
      style: TextStyle(
        color: textColor,
        fontSize: TextSize.medium,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
