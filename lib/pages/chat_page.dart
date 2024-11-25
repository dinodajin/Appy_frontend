import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final List<Map<String, String>> messages = [
    {"text": "드림아 안녕.", "time": "2024-11-18 12:26:00", "type": "user"},
    {
      "text":
          "기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어?",
      "time": "2024-11-18 12:27:00",
      "type": "system"
    },
    {
      "text": "드림아 안녕. 오늘 하루는 어땠어?",
      "time": "2024-11-19 15:10:00",
      "type": "user"
    },
    {
      "text":
          "기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어?",
      "time": "2024-11-19 15:11:00",
      "type": "system"
    },
    {"text": "드림아 안녕.", "time": "2024-11-20 15:10:00", "type": "user"},
    {
      "text":
          "기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어?",
      "time": "2024-11-20 15:11:00",
      "type": "system"
    },
    {"text": "드림아 안녕.", "time": "2024-11-21 15:12:00", "type": "user"},
    {
      "text":
          "기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어?",
      "time": "2024-11-21 15:13:00",
      "type": "system"
    },
    {"text": "드림아 안녕.", "time": "2024-11-21 15:14:00", "type": "user"},
    {
      "text":
          "기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어?",
      "time": "2024-11-21 15:15:00",
      "type": "system"
    },
    {"text": "드림아 안녕.", "time": "2024-11-21 15:16:00", "type": "user"},
    {
      "text":
          "기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어? 기다리고 있었어! 오늘 하루는 어땠어?",
      "time": "2024-11-21 15:17:00",
      "type": "system"
    },
  ];

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko', null);

// 키보드 이벤트 감지를 위해 Observer 등록
    WidgetsBinding.instance.addObserver(this);

    // 페이지가 처음 로드될 때 맨 아래로 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Observer 해제
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    // 키보드 상태 변화 확인
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0.0) {
      // 키보드가 열릴 때 스크롤 하단으로 이동
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildChatAppBar(context, "레비"),
      resizeToAvoidBottomInset: true, // 키보드 열릴 때 레이아웃 조정
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _groupMessagesByDate(messages).length,
              itemBuilder: (context, index) {
                final date =
                    _groupMessagesByDate(messages).keys.toList()[index];
                final dayMessages = _groupMessagesByDate(messages)[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateLabel(date),
                    ...dayMessages.map((message) {
                      return _buildChatBubble(
                        message["text"]!,
                        message["time"]!,
                        message["type"] == "user",
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          _buildChatInput(), // 입력창 추가
        ],
      ),
    );
  }

  Map<String, List<Map<String, String>>> _groupMessagesByDate(
      List<Map<String, String>> messages) {
    final Map<String, List<Map<String, String>>> groupedMessages = {};
    for (var message in messages) {
      final date =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(message["time"]!));
      if (groupedMessages[date] == null) {
        groupedMessages[date] = [];
      }
      groupedMessages[date]!.add(message);
    }
    return groupedMessages;
  }

  Widget _buildDateLabel(String date) {
    final formattedDate =
        DateFormat.yMMMMEEEEd('ko').format(DateTime.parse(date));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: Text(
          formattedDate,
          style: const TextStyle(
            fontFamily: 'SUITE',
            fontSize: TextSize.small,
            color: AppColors.textMedium,
          ),
        ),
      ),
    ); 
  }

  Widget _buildChatBubble(String text, String time, bool isUser) {
    final parsedTime = DateFormat('HH:mm').format(DateTime.parse(time));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Column(
              children: [
                BuildChatImage("assets/images/appy_levi.png"),
                const SizedBox(height: 4),
              ],
            ),
            const SizedBox(width: 10),
          ],
          Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.grey200 : AppColors.accent,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomLeft:
                        isUser ? const Radius.circular(10) : Radius.zero,
                    bottomRight:
                        isUser ? Radius.zero : const Radius.circular(10),
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                      fontFamily: 'SUITE',
                      fontSize: TextSize.small,
                      color: AppColors.textHigh),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                parsedTime,
                style: const TextStyle(
                  fontFamily: 'SUITE',
                  fontSize: TextSize.extraSmall,
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    Color sendButtonColor = AppColors.grey200; // 초기 버튼 색상

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: 107, // 전체 입력창 높이 설정
          decoration: BoxDecoration(
            color: AppColors.background, // 전체 배경색 설정
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // 그림자 색상
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: 353,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.iconBackground, // 입력칸 배경색 설정
                    borderRadius: BorderRadius.circular(40), // 둥근 모서리 설정
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15), // 그림자 색상
                        offset: const Offset(1, 1), // 그림자 위치
                        blurRadius: 4, // 흐림 효과
                        spreadRadius: 0, // 확산 정도
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _messageController,
                    onChanged: (text) {
                      setState(() {
                        // 텍스트 입력 상태에 따른 버튼 색상 변경
                        sendButtonColor =
                            text.isEmpty ? AppColors.grey200 : AppColors.accent;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "메시지를 입력하세요", // 힌트 텍스트
                      hintStyle: TextStyle(
                        fontSize: TextSize.small, // 글자 크기
                        color: Color(0xffB8B8B8), // 텍스트 색상
                      ),
                      border: InputBorder.none, // 입력칸 경계선 제거
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0, 
                        horizontal: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10), // 입력칸과 버튼 간격 설정
              GestureDetector(
                onTap: () {
                  if (_messageController.text.isNotEmpty) {
                    _handleSendMessage();
                    setState(() {
                      // 메시지 전송 후 버튼 색상 초기화
                      sendButtonColor = AppColors.grey200;
                    });
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: sendButtonColor, // 버튼 배경색 동적 변경
                    shape: BoxShape.circle, // 버튼을 원형으로 설정
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_upward, // 화살표 아이콘
                    color: Colors.white, // 아이콘 색상
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          "text": _messageController.text,
          "time": DateTime.now().toIso8601String(),
          "type": "user",
        });
      });
      _messageController.clear();
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom(); // 메시지를 보낸 후 스크롤
      });
    }
  }

  AppBar BuildChatAppBar(BuildContext context, String appyName) {
    return AppBar(
      backgroundColor: AppColors.primary,
      toolbarHeight: 70, // AppBar 높이 설정
      elevation: 0, // AppBar 그림자
      scrolledUnderElevation: 0, // 스크롤 시 추가 elevation 제거
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10), // 하단 좌측 둥근 처리
          bottomRight: Radius.circular(10), // 하단 우측 둥근 처리
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context); // 뒤로가기
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: IconSize.medium,
          color: AppColors.icon,
        ),
      ),
      title: Row(
        children: [
          BuildChatImage("assets/images/appy_levi.png", size: 46), // 아바타 이미지 추가
          const SizedBox(width: 19), // 이미지와 텍스트 간격
          Text(
            appyName,
            style: const TextStyle(
              fontFamily: 'SUITE',
              fontSize: TextSize.large,
              fontWeight: FontWeight.bold,
              color: AppColors.textHigh,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // 검색 버튼
          },
          icon: const Icon(
            Icons.search,
            color: AppColors.icon,
            size: IconSize.medium,
          ),
        ),
      ],
    );
  }

  Widget BuildChatImage(String imagePath, {double size = 46}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
