import 'package:appy_app/pages/diary_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class GiftPage extends StatefulWidget {
  final int characterId = 1; // 캐릭터 ID 전달
  final int characterLevel = 5; // 해당 캐릭터의 레벨
  const GiftPage({super.key});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  final Map<int, Map<int, String>> characterItems = {
    1: {
      1: "assets/icons/gift/gift_1_1.png",
      2: "assets/icons/gift/gift_1_2.png",
      3: "assets/icons/gift/gift_1_3.png",
      4: "assets/icons/gift/gift_1_4.png",
      5: "assets/icons/gift/gift_1_5.png",
      6: "assets/icons/gift/gift_1_6.png",
      7: "assets/icons/gift/gift_1_7.png",
    },
    2: {
      1: "assets/icons/gift/gift_2_1.png",
      2: "assets/icons/gift/gift_2_2.png",
      3: "assets/icons/gift/gift_2_3.png",
      4: "assets/icons/gift/gift_2_4.png",
    },
  };

  @override
  Widget build(BuildContext context) {
    final items = characterItems[widget.characterId] ?? {};
    return Scaffold(
      appBar: BuildBigAppBar(
        context,
        "래비의 선물함",
        "assets/icons/gift_box.png",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42.0),
          child: Column(
            children: [
              const SizedBox(height: 41), // 앱바와 첫 줄 사이 거리
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 한 줄에 3개
                    crossAxisSpacing: 30, // 가로 간격
                    mainAxisSpacing: 42, // 세로 간격
                    childAspectRatio: 1, // 1:1 비율
                  ),
                  itemCount: 12, // 항상 12개의 아이템 슬롯을 렌더링
                  itemBuilder: (context, index) {
                    final level = index + 1; // 레벨 기준
                    if (level <= widget.characterLevel &&
                        items.containsKey(level)) {
                      return GestureDetector(
                        onTap: () {
                          _onUnlockedItemTap(level); // 잠금 해제된 아이템 클릭
                        },
                        child: _buildUnlockedItem(items[level]!),
                      );
                    } else {
                      return _buildLockedItem(); // 잠금 상태 아이템
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 잠금 해제된 아이템 클릭 시 동작
  void _onUnlockedItemTap(int level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryPage(
          characterId: widget.characterId,
          itemLevel: level,
        ),
      ),
    );
  }

  // 잠금 해제된 아이템
  Widget _buildUnlockedItem(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.iconBackgroundRight,
        borderRadius: BorderRadius.circular(15), // 코너 15
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 2), // 그림자 위치
            blurRadius: 6, // 흐림 정도
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0), // 이미지에 추가적인 여백 설정
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // 잠금된 아이템
  Widget _buildLockedItem() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.iconBackgroundRight,
        borderRadius: BorderRadius.circular(15), // 코너 15
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 2), // 그림자 위치
            blurRadius: 6, // 흐림 정도
          ),
        ],
      ),
      child: const Center(
        child: Image(
          image: AssetImage("assets/icons/gift/gift_lock.png"), // 잠금 아이콘
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
