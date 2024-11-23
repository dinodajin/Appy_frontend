import 'dart:async';
import 'dart:math';

import 'package:appy_app/pages/chat_page.dart';
import 'package:appy_app/pages/gift_page.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// home에서 에피 하나를 눌렀을때 에피와 상호작용할 수 있는 페이지
class AppyPage extends StatefulWidget {
  const AppyPage({
    super.key,
  });

  @override
  State<AppyPage> createState() => _AppyPageState();
}

class _AppyPageState extends State<AppyPage> {
  // 텍스트 리스트
  final List<String> texts = [
    "안녕! 좋은 아침이야. 오늘도 행복한 하루 보내!",
    "오늘은 무엇을 해볼까? 멋진 하루가 될 거야!",
    "힘들 땐 잠시 쉬어도 괜찮아. 넌 잘하고 있어!",
    "모든 순간을 즐겨봐. 넌 특별한 사람이야!",
    "파이팅! 오늘도 최선을 다해보자!"
  ];

  late String randomText;
  bool _isAnimating = false; // 애니메이션 상태 플래그

  @override
  void initState() {
    super.initState();
    _getRandomText(); // 초기화 시 랜덤 텍스트 설정
  }

  // 랜덤 텍스트 선택
  void _getRandomText() {
    final random = Random();
    randomText = texts[random.nextInt(texts.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.homeBackground,
        appBar: BuildAppBar(context),
        body: Stack(
          children: [
            //배경 색상 나누기
            Column(
              children: [
                Flexible(
                    child: Container(
                  color: Colors.transparent,
                )),
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
                    Container(
                      height: 400,
                      child: Image.asset(
                        "assets/images/appy_background2.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    // 에피
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 10,
                        ),
                        //말풍선 영역
                        GestureDetector(
                          onTap: () {
                            if (!_isAnimating) {
                              setState(() {
                                _getRandomText(); //말풍선 클릭시 텍스트 변경
                                _isAnimating = true; // 애니메이션 시작
                              });
                            }
                          },
                          child: Container(
                            height: 90,
                            child: SpeechBubble(
                                text: randomText,
                                onAnimationEnd: () {
                                  setState(() {
                                    _isAnimating = false; //애니메이션 종료
                                  });
                                }),
                          ),
                        ),
                        Container(
                          height: 30,
                        ),
                        // 에피 영역
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 이전 에피로 이동 버튼
                            IconButton(
                                onPressed: () {},
                                icon: FaIcon(
                                  FontAwesomeIcons.caretLeft,
                                  size: IconSize.large,
                                  color: AppColors.background.withOpacity(0.8),
                                )),
                            // 에피 이미지
                            Image.asset(
                              "assets/images/appy_levi.png",
                              height: 200,
                            ),
                            // 다음 에피로 이동 버튼
                            IconButton(
                                onPressed: () {},
                                icon: FaIcon(
                                  FontAwesomeIcons.caretRight,
                                  size: IconSize.large,
                                  color: AppColors.background.withOpacity(0.8),
                                )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                //에피배경 그림자생성
                Container(
                  height: 1,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      blurRadius: 5.0,
                      spreadRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  // 에피 이름 가져오기
                  child: Text(
                    "래비",
                    style: TextStyle(
                      fontSize: TextSize.large,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Stack(children: [
                  Padding(
                      padding: AppPadding.body,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildFeedButton(),
                            Container(
                              width: 7,
                            ),
                            _buildChatButton(),
                            Container(
                              width: 7,
                            ),
                            _buildGiftButton(),
                          ])),
                ]),
              ],
            ),
          ],
        ));
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
        fixedSize: const Size(110, 130),
        // 텍스트 칼라
        foregroundColor: AppColors.textHigh,
        // 메인 칼라
        backgroundColor: AppColors.iconBackground,
        elevation: 3,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: TextSize.tiny,
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
            width: 105,
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
        fixedSize: const Size(110, 130),
        // 텍스트 칼라
        foregroundColor: AppColors.textHigh,
        // 메인 칼라
        backgroundColor: AppColors.iconBackground,
        elevation: 3,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: TextSize.tiny,
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
        fixedSize: const Size(110, 130),
        // 텍스트 칼라
        foregroundColor: AppColors.textHigh,
        // 메인 칼라
        backgroundColor: AppColors.iconBackground,
        elevation: 3,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: TextSize.tiny,
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

class SpeechBubble extends StatefulWidget {
  final String text;
  final Duration duration;
  final double maxWidth; // 최대 가로 길이
  final VoidCallback? onAnimationEnd; // 애니메이션 종료 콜백

  const SpeechBubble({
    required this.text,
    this.duration = const Duration(milliseconds: 100),
    this.maxWidth = 310,
    this.onAnimationEnd,
    Key? key,
  }) : super(key: key);

  @override
  _SpeechBubbleState createState() => _SpeechBubbleState();
}

class _SpeechBubbleState extends State<SpeechBubble> {
  String displayedText = "";
  double bubbleWidth = 80; // 초기 말풍선 크기
  Timer? _typingTimer; // 기존 타이머를 관리하기 위한 변수

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
    int index = 0;

    // 기존 타이머 취소
    _typingTimer?.cancel();

    // 텍스트 초기화
    setState(() {
      displayedText = "";
      bubbleWidth = 70; // 초기 크기
    });

    // 타이핑 애니메이션 시작
    _typingTimer = Timer.periodic(widget.duration, (timer) {
      if (index < widget.text.length) {
        setState(() {
          displayedText += widget.text[index];
          double calWidth = displayedText.length * 13.0 + 80; // 글자 수에 따라 크기 증가
          bubbleWidth = calWidth > widget.maxWidth
              ? widget.maxWidth
              : calWidth; // 최대 크기 제한
          index++;
        });
      } else {
        timer.cancel();
        widget.onAnimationEnd?.call(); // 애니메이션 종료 시 콜백 호출
      }
    });
  }

  void _resetTyping() {
    _startTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel(); // 타이머 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        alignment: Alignment.center, // 컨테이너 내부 내용 가운데 정렬
        width: bubbleWidth,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
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
          textAlign: TextAlign.center, // 텍스트 가운데 정렬
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
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
//               fontSize: TextSize.tiny,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         );
// }

