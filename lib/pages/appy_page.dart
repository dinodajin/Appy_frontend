import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:appy_app/pages/chat_page.dart';
import 'package:appy_app/pages/gift_page.dart';
import 'package:appy_app/pages/home_page.dart';
import 'package:appy_app/widgets/appy.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:appy_app/pages/home_page.dart';
import 'package:appy_app/providers/user_provider.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/appy.dart';

class AppyPage extends StatefulWidget {
  final List<Map<String, dynamic>> userRfids; // 사용자 RFID 목록과 관련 데이터를 포함
  final int initialIndex; // 초기 인덱스

  const AppyPage({
    required this.userRfids,
    this.initialIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<AppyPage> createState() => _AppyPageState();
}

class _AppyPageState extends State<AppyPage> {
  late String randomText;
  bool _isAnimating = true;
  bool _isNewChat = false;
  bool _isNewGift = false;
  String? lastText;

  late int currentIndex; // 현재 인덱스
  late String rfid;
  late int characterType;
  late String characterName;
  late int currentSnackCount;
  late int currentGauge;
  late int currentLevel;

  final maxSteps = 7;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _initializeData(currentIndex);
    _getRandomText(characterTexts[characterType]);
  }

  void _initializeData(int index) {
    final currentData = widget.userRfids[index];
    print(currentData);
    setState(() {
      rfid = currentData['rfidId'];
      characterType = currentData['characterType'];
      characterName = currentData['characterName'];
      currentSnackCount = currentData['snackCount'];
      currentGauge = currentData['gauge'];
      currentLevel = currentData['characterLevel'];
    });
  }

  void _updatePage(bool isNext) {
    setState(() {
      currentIndex = isNext
          ? (currentIndex + 1) % widget.userRfids.length // 원형 반복
          : (currentIndex - 1 + widget.userRfids.length) %
              widget.userRfids.length; // 역방향 원형 반복

      _initializeData(currentIndex);
      _getRandomText(characterTexts[characterType]); // 캐릭터 타입에 따라 말풍선 텍스트 변경
    });
  }

  // 랜덤 텍스트 선택
  void _getRandomText(List<String> textList) {
    final random = Random();
    String newText;
    do {
      newText = textList[random.nextInt(textList.length)];
    } while (newText == lastText);
    randomText = newText;
    lastText = newText;
  }

  // 간식 및 레벨, 게이지 업데이트 API 호출
  Future<void> _updateAppyStatus() async {
    final apiUrl = "http://192.168.0.50:8083/api/character/updateAppy";
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String userId = userProvider.userId;

    try {
      final response = await http.patch(
        Uri.parse("$apiUrl?userId=${userId}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "RFID_ID": rfid,
          "SNACK_COUNT": currentSnackCount,
          "GAUGE": currentGauge,
          "CHARACTER_LEVEL": currentLevel,
        }),
      );

      if (response.statusCode == 200) {
        print("간식, 게이지, 레벨 업데이트 성공");
      } else {
        print("간식, 게이지, 레벨 업데이트 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("에러 발생: $e");
    }
  }

  // 사탕 주기 로직
  void _feed(characterType) async {
    if (currentSnackCount > 0) {
      setState(() {
        currentSnackCount--;
        currentGauge++;
        _getRandomText(snackTexts[characterType]);

        if (currentGauge >= maxSteps) {
          currentGauge = 0;
          currentLevel++;

          showCustomErrorDialog(
            context: context,
            message: "${appyNamesKo[characterType]}의 선물이 도착했습니다.\n선물함을 확인해주세요.",
            buttonText: "확인",
            onConfirm: () {
              Navigator.of(context).pop();
              setState(() {
                _isNewGift = true;
              });
            },
          );
        }
      });

      await _updateAppyStatus(); // 업데이트 동기화
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("사탕이 없습니다!"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.homeBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 70,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: AppColors.icon,
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 300,
                  color: Colors.transparent,
                ),
                Flexible(
                  child: Container(
                    color: AppColors.background,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      bottom: 0, // 하단에 위치
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 20, // 그림자가 적용될 영역 높이
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30), // 왼쪽 하단 모서리 둥글게
                            bottomRight: Radius.circular(30), // 오른쪽 하단 모서리 둥글게
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 5.0, // 그림자 흐림 정도
                              spreadRadius: 1.0, // 그림자 확산 정도
                              offset: const Offset(0, 2), // 그림자 방향
                            ),
                          ],
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.48,
                        child: Image.asset(
                          "assets/images/appy_background2.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 90,
                          child: SpeechBubble(
                            text: randomText,
                            onAnimationEnd: () {
                              setState(() {
                                _isAnimating = false;
                              });
                            },
                          ),
                        ),
                        Container(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!_isAnimating) {
                              setState(() {
                                _getRandomText(characterTexts[
                                    characterType]); //말풍선 클릭시 텍스트 변경
                                _isAnimating = true;
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 이전 에피
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.caretLeft,
                                  size: IconSize.large,
                                  color: AppColors.background.withOpacity(0.8),
                                ),
                                onPressed: () {
                                  if (widget.userRfids.length > 1) {
                                    _updatePage(false);
                                  }
                                },
                              ),
                              // 에피 이미지
                              Image.asset(
                                "assets/images/${appySideImages[characterType]}",
                                height: 240,
                              ),
                              // 다음 에피
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.caretRight,
                                  size: IconSize.large,
                                  color: AppColors.background.withOpacity(0.8),
                                ),
                                onPressed: () {
                                  if (widget.userRfids.length > 1) {
                                    _updatePage(false);
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  // 에피 이름 가져오기
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isNewChat = !_isNewChat;
                      });
                    },
                    child: Text(
                      appyNamesKo[characterType],
                      style: const TextStyle(
                        fontSize: TextSize.large,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                //하단 상호작용 영역
                Stack(children: [
                  Stack(
                    clipBehavior: Clip.none, // Stack에서 그림자가 잘리지 않도록 설정
                    children: [
                      // 그림자 영역
                      Container(
                        height: 100, // 컨테이너 높이
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20), // 상단 왼쪽 둥글게
                            topRight: Radius.circular(20), // 상단 오른쪽 둥글게
                          ),
                          color: Colors.transparent, // 배경 투명
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 3.0, // 흐림 정도
                              spreadRadius: 1, // 확산 범위
                              offset: const Offset(0, -2), // 상단 방향으로 그림자 이동
                            ),
                          ],
                        ),
                      ),
                      // 메인 컨테이너 (하단 그림자 제거)
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        decoration: const BoxDecoration(
                          color: AppColors.background, // 하단 배경과 동일한 색상
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20), // 상단 왼쪽 둥글게
                            topRight: Radius.circular(20), // 상단 오른쪽 둥글게
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: AppPadding.body,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LinearPercentIndicator(
                                backgroundColor: AppColors.iconBackground,
                                alignment: MainAxisAlignment.center,
                                width: MediaQuery.of(context).size.width * 0.8,
                                animation: true,
                                animationDuration: 200,
                                animateFromLastPercent: true,
                                percent: currentGauge / maxSteps,
                                lineHeight: 28.0,
                                barRadius: const Radius.circular(15.0),
                                progressColor: AppColors.accent,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentSnackCount++;
                                  });
                                },
                                child: Image.asset(
                                  "assets/icons/gift_box_question.png",
                                  height: 40,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (currentSnackCount > 0) {
                                          _feed(characterType); // 사탕 주기 로직 실행
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            duration: Duration(seconds: 1),
                                            backgroundColor: AppColors.primary,
                                            content: Center(
                                                child: Text("사탕이 없습니다!",
                                                    style: TextStyle(
                                                      color: AppColors.textHigh,
                                                      fontSize: TextSize.small,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ))),
                                          ));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(3.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        fixedSize: const Size(105, 130),
                                        // 텍스트 칼라
                                        foregroundColor: AppColors.textHigh,
                                        // 메인 칼라
                                        backgroundColor:
                                            AppColors.iconBackground,
                                        elevation: 7,
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: TextSize.small,
                                          fontFamily: "SUITE",
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/candy.png",
                                            width: 60,
                                          ),
                                          Container(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: 105,
                                            child: const Center(
                                              child: Text(
                                                "사탕 주기",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Text(
                                        "$currentSnackCount",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  width: 5,
                                ),
                                //대화하기 버튼
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isNewChat = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                  rfid: rfid,
                                                )));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(3.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    fixedSize: const Size(105, 130),
                                    // 텍스트 칼라
                                    foregroundColor: AppColors.textHigh,
                                    // 메인 칼라
                                    backgroundColor: AppColors.iconBackground,
                                    elevation: 7,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: TextSize.small,
                                      fontFamily: "SUITE",
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/chat.png",
                                            width: 60,
                                          ),
                                          Container(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: 105,
                                            child: const Center(
                                              child: Text(
                                                "대화하기",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (_isNewChat)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Image.asset(
                                            "assets/icons/exclamation.png",
                                            height: 30,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: 5,
                                ),
                                //선물함 버튼
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isNewGift = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GiftPage(
                                                  characterId:
                                                      RFIDS.indexOf(rfid) + 1,
                                                  characterLevel: currentLevel,
                                                )));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(3.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    fixedSize: const Size(105, 130),
                                    // 텍스트 칼라
                                    foregroundColor: AppColors.textHigh,
                                    // 메인 칼라
                                    backgroundColor: AppColors.iconBackground,
                                    elevation: 7,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: TextSize.small,
                                      fontFamily: "SUITE",
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/gift_box.png",
                                            width: 60,
                                          ),
                                          Container(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: 105,
                                            child: const Center(
                                              child: Text(
                                                "선물함",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (_isNewGift)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Image.asset(
                                            "assets/icons/exclamation.png",
                                            height: 30,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ]),
                        ],
                      )),
                ]),
              ],
            ),
          ],
        ));
  }
}

class SpeechBubble extends StatefulWidget {
  final String text;
  final Duration duration;
  final double maxWidth;
  final VoidCallback? onAnimationEnd;

  const SpeechBubble({
    required this.text,
    this.duration = const Duration(milliseconds: 70),
    this.maxWidth = 310,
    this.onAnimationEnd,
    super.key,
  });

  @override
  _SpeechBubbleState createState() => _SpeechBubbleState();
}

class _SpeechBubbleState extends State<SpeechBubble> {
  String displayedText = "";
  double bubbleWidth = 80;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(SpeechBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _resetTyping();
    }
  }

  void _startTyping() {
    _typingTimer?.cancel();
    setState(() {
      displayedText = "";
      bubbleWidth = 80;
    });

    int index = 0;
    _typingTimer = Timer.periodic(widget.duration, (timer) {
      if (index < widget.text.length) {
        setState(() {
          displayedText += widget.text[index++];
          bubbleWidth = (displayedText.length * 13.0 + 80)
              .clamp(80, widget.maxWidth); // 크기 조정
        });
      } else {
        timer.cancel();
        widget.onAnimationEnd?.call(); // 애니메이션 종료
      }
    });
  }

  void _resetTyping() {
    _startTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      alignment: Alignment.center,
      width: bubbleWidth,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: AppColors.iconShadow,
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Text(
        displayedText,
        style: const TextStyle(
          color: AppColors.textHigh,
          fontSize: TextSize.small,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    toolbarHeight: 70,
    centerTitle: true,
    leading: IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
      icon: const Icon(
        Icons.arrow_back_ios,
        size: IconSize.medium,
        color: AppColors.icon,
      ),
    ),
  );
}
