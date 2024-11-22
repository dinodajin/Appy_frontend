import 'package:appy_app/pages/home_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:appy_app/widgets/widget.dart';

class AddAppyPage extends StatefulWidget {
  const AddAppyPage({
    super.key,
  });

  @override
  State<AddAppyPage> createState() => _AddAppyPageState();
}

class _AddAppyPageState extends State<AddAppyPage> {

  bool _showImage = false; // 이미지 표시 여부

  @override
  void initState() {
    super.initState();

    // 3초 후에 이미지 표시 여부 상태 변경
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showImage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSettingAppBar(context, "Appy 등록"),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 등록된 모듈 이름 가져오기
                Column(
                  children: [
                      Column(
                        children: [
                          Container(
                            height: 20,
                          ),
                          // 연결된 모듈 이름이 표시됨
                          const Text(
                            "MOA TV",
                            style: TextStyle(
                              color: AppColors.textMedium,
                              fontSize: TextSize.medium,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Container(
                            color: AppColors.buttonDisabled,
                            height: 1,
                          ),
                          Container(
                            height: 100,
                          ),
                          Container(
                            child:
                            _showImage
                            ? Column(
                              children: [
                                Image.asset("assets/images/appy_levi.png"),
                                Container(height: 100,),

                                GestureDetector(
                                  onTap: () {
                                    // 로그인 처리 api
                                    // 수정 필요
                                    
                                    // 페이지 이동
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => const HomePage()));
                                  },
                                  child: buildButton("이 Appy를 등록하기", AppColors.accent),
                                )

                                
                              ],
                            )
                              
                      
                            : const Text(
                              "장착된 Appy를 확인할 수 없습니다",
                              style: TextStyle(
                                color: AppColors.textHigh,
                                fontSize: TextSize.medium,
                                fontWeight: FontWeight.w700,
                              )
                              ),
                          )
                        ],
                      ),
                  ],
                ),
            ],
          ),
        ))
        ,
    );
  }
}