import 'package:appy_app/pages/chat_page.dart';
import 'package:appy_app/pages/gift_page.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';

// home에서 에피 하나를 눌렀을때 에피와 상호작용할 수 있는 페이지
class AppyPage extends StatelessWidget {
  const AppyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BuildAppBar(context),
        body: SafeArea(
            child: Padding(
                padding: AppPadding.body,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildFeedButton(),
                      Container(
                        width: 5,
                      ),
                      _buildChatButton(),
                      Container(
                        width: 5,
                      ),
                      _buildGiftButton(),
                    ]))));
  }
}

class _buildFeedButton extends StatelessWidget {
  const _buildFeedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        fixedSize: const Size(105, 130),
        // 텍스트 칼라
        foregroundColor: AppColors.textHigh,
        // 메인 칼라
        backgroundColor: AppColors.iconBackground,
        elevation: 3,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: TextSize.small,
          fontFamily: "SUITE",
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/candy.png",
            width: 60,
          ),
          Container(
            height: 5,
          ),
          Container(
            width: 100,
            child: Center(
              child: Text(
                "사탕 주기",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _buildChatButton extends StatelessWidget {
  const _buildChatButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ChatPage()));
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        fixedSize: const Size(105, 130),
        // 텍스트 칼라
        foregroundColor: AppColors.textHigh,
        // 메인 칼라
        backgroundColor: AppColors.iconBackground,
        elevation: 3,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: TextSize.small,
          fontFamily: "SUITE",
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/chat.png",
            width: 60,
          ),
          Container(
            height: 5,
          ),
          Container(
            width: 100,
            child: Center(
              child: Text(
                "대화하기",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _buildGiftButton extends StatelessWidget {
  const _buildGiftButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GiftPage()));
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        fixedSize: const Size(105, 130),
        // 텍스트 칼라
        foregroundColor: AppColors.textHigh,
        // 메인 칼라
        backgroundColor: AppColors.iconBackground,
        elevation: 3,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: TextSize.small,
          fontFamily: "SUITE",
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/gift_box.png",
            width: 60,
          ),
          Container(
            height: 5,
          ),
          Container(
            width: 100,
            child: Center(
              child: Text(
                "선물함",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// Container _buildInteractionButton(String buttonName) {
//   return Container(
//           width: 100,
//           height: 120,
//           decoration: BoxDecoration(
//             color: AppColors.iconBackground,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             buttonName,
//             style: const TextStyle(
//               color: AppColors.textHigh,
//               fontSize: TextSize.small,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         );
// }

