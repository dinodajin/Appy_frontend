import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';

//채팅창
class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildChatAppBar(context, "래비"),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}

AppBar _buildChatAppBar(BuildContext context, String appyName) {
  return AppBar(
    backgroundColor: AppColors.primary,
    toolbarHeight: 70,
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context); //이전 페이지로 돌아가기
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: IconSize.medium,
          color: AppColors.icon,
        )),
    title: Row(
      children: [
        Image.asset(
          "assets/images/appy_levi.png",
          width: 50,
          height: 50,
        ),
        Text(
          appyName,
          style: const TextStyle(
            fontSize: TextSize.medium,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
