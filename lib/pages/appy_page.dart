import 'dart:async';
import 'dart:math';

import 'package:appy_app/pages/chat_page.dart';
import 'package:appy_app/pages/gift_page.dart';
import 'package:appy_app/pages/home_page.dart';
import 'package:appy_app/widgets/appy.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// home에서 에피 하나를 눌렀을때 에피와 상호작용할 수 있는 페이지
class AppyPage extends StatefulWidget {
  final String RFID;
  final int appyType; // Appy의 ID
  const AppyPage({
    required this.RFID, //이름 초기화
    required this.appyType, // Appy의 ID
    super.key,
  });

  @override
  State<AppyPage> createState() => _AppyPageState();
}

class _AppyPageState extends State<AppyPage> {
  late String randomText;
  bool _isAnimating = true; // 애니메이션 상태 플래그
  bool _isNewChat = false; // 새로운 채팅
  bool _isNewGift = false;
  String? lastText; // 랜덤 텍스트 선택 중복 방지용

  // 각 RFID에 따른 사탕 개수 관리
  final Map<String, int> candyNumByRFID = {
    "195307716957": 3,
    "02719612895": 5,
    "1761222116188": 2,
  };

  // 현재 RFID의 사탕 개수
  int get currentCandyNum => candyNumByRFID[widget.RFID] ?? 0;

  // 현재 RFID의 사탕 개수 설정
  set currentCandyNum(int value) {
    candyNumByRFID[widget.RFID] = value;
  }


  // 각 RFID에 따른 진행 상태 관리
  final Map<String, int> progressNumByRFID = {
    "195307716957": 2,
    "02719612895": 4,
    "1761222116188": 6,
  };

  final double maxSteps = 7; // 최대 단계 수

  // 현재 RFID의 진행 상태
  int get currentProgressNum => progressNumByRFID[widget.RFID] ?? 0;

  // 현재 RFID의 진행 상태 설정
  set currentProgressNum(int value) {
    progressNumByRFID[widget.RFID] = value;
  }


//
  // 각 RFID에 따른 선물함 레벨 관리
  final Map<String, int> levelByRFID = {
    "195307716957": 3,
    "02719612895": 3,
    "1761222116188": 3,
  };

 // 현재 RFID의 진행 상태
  int get currentLevel => levelByRFID[widget.RFID] ?? 0;

  // 현재 RFID의 진행 상태 설정
  set cuurrentLevel(int value) {
    levelByRFID[widget.RFID] = value;
  }



  @override
  void initState() {
    super.initState();
    String RFID = widget.RFID;
    int appyType = widget.appyType;
    int currentProgressNum = appyLevels[widget.appyType];

    _getRandomText(characterTexts[appyType]); // 초기화 시 랜덤 텍스트 설정
  }

  // 랜덤 텍스트 선택
  void _getRandomText(List<String> textList) {
    final random = Random();
    String newText;
    do {
      newText = textList[random.nextInt(textList.length)];
    } while (newText == lastText); // 이전 텍스트와 동일하면 다시 선택
    randomText = newText;
    lastText = newText;
  }

  // 프로그레스 바 단계별 증가
  void _feed(appyType) async {
    setState(() {
      currentCandyNum--;
      currentProgressNum += 1; // 단계별 증가

      // 말풍선 텍스트를 간식 텍스트 중 랜덤하게 선택
      _getRandomText(snackTexts[appyType]);

      if (currentProgressNum >= maxSteps) {
        showCustomErrorDialog(
          context: context,
          message: "${appyNamesKo[appyType]}의 선물이 도착했습니다.\n선물함을 확인해주세요.",
          buttonText: "확인",
          onConfirm: () {
            Navigator.of(context).pop();
            setState(() {
              _isNewGift = true;
            });
          },
        ); // 최대값 도달 시 팝업 호출
        currentProgressNum = 0; // 진행 상태 초기화
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.homeBackground,
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            //배경 색상 나누기
            Column(
              children: [
                Container(
                  height: 300,
                  color: Colors.transparent,
                ),
                Flexible(
                    child: Container(
                  color: AppColors.background,
                ))
              ],
            ),
            // 에피영역과 상호작용영역 나누기
            Column(
              children: [
                Stack(
                  children: [
                    //배경
                    Stack(
                      children: [
                        // 하단 그림자 영역
                        Positioned(
                          bottom: 0, // 하단에 위치
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 20, // 그림자가 적용될 영역 높이
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(30), // 왼쪽 하단 모서리 둥글게
                                bottomRight:
                                    Radius.circular(30), // 오른쪽 하단 모서리 둥글게
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
                        // 이미지 하단 모서리 둥글게
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20), // 왼쪽 하단 모서리 둥글게
                            bottomRight: Radius.circular(20), // 오른쪽 하단 모서리 둥글게
                          ),
                          child: SizedBox(
                            height: 370,
                            child: Image.asset(
                              "assets/images/appy_background2.png",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 에피
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //말풍선 영역
                        SizedBox(
                          height: 90,
                          child: SpeechBubble(
                              text: randomText,
                              onAnimationEnd: () {
                                setState(() {
                                  _isAnimating = false; //애니메이션 종료
                                });
                              }),
                        ),
                        Container(
                          height: 20,
                        ),
                        // 에피 영역
                        GestureDetector(
                          onTap: () {
                            if (!_isAnimating) {
                              setState(() {
                                _getRandomText(characterTexts[
                                    widget.appyType]); //말풍선 클릭시 텍스트 변경
                                _isAnimating = true; // 애니메이션 시작
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 이전 에피로 이동 버튼
                              IconButton(
                                  onPressed: () {
                                    // 이전 인덱스가 있는 경우
                                    int preIndex =
                                        RFIDS.indexOf(widget.RFID) - 1;
                                    if (preIndex >= 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AppyPage(
                                            RFID: RFIDS[preIndex],
                                            appyType: appyTypes[preIndex],
                                          ),
                                        ),
                                      );
                                    } else {
                                      // 동작 안하기
                                    }
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.caretLeft,
                                    size: IconSize.large,
                                    color:
                                        AppColors.background.withOpacity(0.8),
                                  )),
                              // 에피 이미지
                              Image.asset(
                                "assets/images/${appySideImages[widget.appyType]}",
                                height: 240,
                              ),
                              // 다음 에피로 이동 버튼
                              IconButton(
                                  onPressed: () {
                                    // 다음 인덱스가 있는 경우
                                    int nextIndex =
                                        RFIDS.indexOf(widget.RFID) + 1;
                                    if (nextIndex < RFIDS.length) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AppyPage(
                                            RFID: RFIDS[nextIndex],
                                            appyType: appyTypes[nextIndex],
                                          ),
                                        ),
                                      );
                                    } else {
                                      // 동작 안하기
                                    }
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.caretRight,
                                    size: IconSize.large,
                                    color:
                                        AppColors.background.withOpacity(0.8),
                                  )),
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
                      appyNamesKo[widget.appyType],
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
                        height: 200,
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
                              //프로그레스 바
                              LinearPercentIndicator(
                                backgroundColor: AppColors.iconBackground,
                                alignment: MainAxisAlignment.center,
                                width: MediaQuery.of(context).size.width * 0.8,
                                animation: true,
                                animationDuration: 200,
                                animateFromLastPercent: true,
                                percent: currentProgressNum / maxSteps,
                                lineHeight: 28.0,
                                // center: Text('$currentProgressNum',
                                //     style: TextStyle(
                                //       color: AppColors.textWhite,
                                //     )),
                                barRadius: const Radius.circular(15.0),
                                progressColor: AppColors.accent,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentCandyNum++;
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
                                        if (currentCandyNum > 0) {
                                          _feed(widget.appyType); // 사탕 주기 로직 실행
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
                                    //사탕 개수 표시
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Text(
                                        "$currentCandyNum개",
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
                                            builder: (context) =>
                                                const ChatPage()));
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
                                                  characterId: RFIDS.indexOf(
                                                          widget.RFID) +
                                                      1,
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
                  builder: (context) =>
                      const HomePage()));
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: IconSize.medium,
          color: AppColors.icon,
        )),
  );
}