
import 'package:appy_app/pages/home_page.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';

class AppyPage extends StatelessWidget {
  const AppyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // 페이지 이동
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const HomePage()));
                },
                child: _buildInteractionButton("사탕 주기"),
              ),

              buildElevatedButton(),

            ]
          )
        )
      )
    );
  }

}

class buildElevatedButton extends StatelessWidget {
  const buildElevatedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => const HomePage()));
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        fixedSize: const Size(110, 130),
        // 텍스트 칼라
        foregroundColor: AppColors.textHigh,
        // 메인 칼라
        backgroundColor: AppColors.iconBackground,
        elevation: 5,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: TextSize.small,
          fontFamily: "SUITE",
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/candy.png",
            width: 60,
            ),
          Text(
            "사탕 주기",
          ),
        ],
      ),  
    );
  }
}


Container _buildInteractionButton(String buttonName) {
  return Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.iconBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            buttonName,
            style: const TextStyle(
              color: AppColors.textHigh,
              fontSize: TextSize.small,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
}