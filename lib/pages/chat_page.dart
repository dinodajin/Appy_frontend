import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final List<Map<String, String>> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String apiUrl = 'http://43.203.220.44:8082/api/chat';

  Timer? _pollingTimer; // 폴링 타이머

  bool _isSearchMode = false;
  String _searchQuery = "";
  List<int> _highlightedMessageIndices = [];
  bool _isModuleConnected = true; // 모듈 연결 상태 변수

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko', null);
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMessages().then((_) {
        _scrollToBottom(); // 데이터 로드 이후 스크롤 이동
      });
    });

    // 5초 간격으로 서버에서 메시지 확인
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _fetchMessages(); // 서버에서 새로운 메시지 확인
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _scrollController.dispose();
    _pollingTimer?.cancel(); // 폴링 종료
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0.0) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/messages'),
        headers: {'Accept': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          messages.clear();
          messages.addAll(data.map((item) {
            final Map<String, dynamic> message = item as Map<String, dynamic>;
            return {
              'text': message['content'] as String? ?? '',
              'time': message['createdAt'] as String? ??
                  DateTime.now().toIso8601String(),
              'type': message['sender'] == 'USER' ? 'USER' : 'AI',
            };
          }).toList());
          messages.sort((a, b) =>
              DateTime.parse(a['time']!).compareTo(DateTime.parse(b['time']!)));
        });

        // 메시지 로드 후 스크롤을 최하단으로 이동
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      } else {
        throw Exception(
            'Failed to load messages. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  Future<void> _sendMessage(String content) async {
    if (content.isEmpty) return;
    try {
      // 메시지 전송 전 UI에 즉시 추가
      setState(() {
        messages.add({
          "text": content,
          "time": DateTime.now().toIso8601String(),
          "type": "USER",
        });
        _messageController.clear(); // 입력창 초기화
        FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기
      });
      _scrollToBottom();

      final message = {
        'content': content,
        'userId': 'user3@example.com',
        "sender": 'USER',
      };

      final response = await http.post(
        Uri.parse('$apiUrl/send'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(message),
      );
    } catch (error) {
      print('Error sending message: $error');
    }
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

  AppBar _buildAppBar() {
    if (_isSearchMode) {
      return AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: 70,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.search, color: AppColors.icon),
          onPressed: () {
            setState(() {
              _isSearchMode = false;
              _searchQuery = "";
            });
          },
        ),
        title: TextField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: "메시지 검색",
            hintStyle: TextStyle(color: AppColors.textMedium),
            border: InputBorder.none,
          ),
          style: TextStyle(color: AppColors.textHigh),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isSearchMode = false;
                _searchQuery = "";
                _highlightedMessageIndices.clear();
              });
            },
          ),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: 70,
        elevation: 0,
        scrolledUnderElevation: 0, // 스크롤 시 추가 elevation 제거
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: IconSize.medium,
            color: AppColors.icon,
          ),
        ),
        title: Row(
          children: [
            BuildChatImage("assets/images/appy_levi_crop.png", size: 46),
            const SizedBox(width: 19),
            Text(
              "레비",
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
              setState(() {
                _isSearchMode = true;
              });
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

    // 검색된 단어 하이라이트
    List<TextSpan> _highlightText(String text, String query) {
      if (query.isEmpty) return [TextSpan(text: text)];

      final matches = text.split(RegExp(query, caseSensitive: false));
      final spans = <TextSpan>[];

      for (var i = 0; i < matches.length; i++) {
        spans.add(TextSpan(text: matches[i]));
        if (i < matches.length - 1) {
          spans.add(TextSpan(
            text: query,
            style: TextStyle(
              backgroundColor: Colors.black,
              color: Colors.white,
            ),
          ));
        }
      }
      return spans;
    }

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
                BuildChatImage("assets/images/appy_levi_crop.png"),
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
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontFamily: 'SUITE',
                        fontSize: TextSize.small,
                        color: AppColors.textHigh),
                    children: _highlightText(text, _searchQuery),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                parsedTime,
                style: const TextStyle(
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
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 353,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.iconBackground,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(1, 1),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: TextField(
                controller: _messageController,
                onChanged: (text) {
                  setState(() {}); // 버튼 색상 변경
                },
                decoration: const InputDecoration(
                  hintText: "메시지를 입력하세요",
                  hintStyle: TextStyle(
                    fontSize: TextSize.small,
                    color: Color(0xffB8B8B8),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (_messageController.text.isNotEmpty) {
                _sendMessage(_messageController.text); // 메시지 전송
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _messageController.text.isNotEmpty
                    ? AppColors.accent
                    : AppColors.grey200, // 입력 상태에 따른 버튼 색상
                shape: BoxShape.circle,
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
                Icons.arrow_upward,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
                        message["type"] == "USER",
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }
}

Widget BuildChatImage(String imagePath, {double size = 46}) {
  return ClipRRect(
    child: Image.asset(
      imagePath,
      width: size,
      height: size,
      fit: BoxFit.cover,
    ),
  );
}
