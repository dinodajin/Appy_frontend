import 'package:appy_app/pages/diary_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:flutter/material.dart';

//채팅창
class GiftPage extends StatefulWidget {
  const GiftPage({
    super.key,
  });

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //에피 이름에 따라 00의 선물함으로 표시
      appBar: BuildBigAppBar(context, "래비의 선물함", "assets/icons/gift_box.png"),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DiaryPage()));
                },
                child: Container(
                  width: 80,
                  height: 80,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.iconBackgroundRight,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.iconBackground,
                          blurRadius: 2.0,
                          spreadRadius: 2.0,
                          offset: Offset(
                            1,
                            2,
                          )),
                    ],
                  ),
                  child: Image.asset(
                    "assets/icons/gift_star.png",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
