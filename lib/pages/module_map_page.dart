import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';

class ModuleMapPage extends StatefulWidget {
  const ModuleMapPage({super.key});

  @override
  State<ModuleMapPage> createState() => _ModuleMapPageState();
}

class _ModuleMapPageState extends State<ModuleMapPage>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    // 첫 번째 애니메이션 컨트롤러
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // 첫 번째 이미지 애니메이션
    )..repeat(reverse: true);

    _animation1 = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: Curves.easeInOut,
      ),
    );

    // 두 번째 애니메이션 컨트롤러
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // 두 번째 이미지 애니메이션
    )..repeat(reverse: true);

    _animation2 = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.easeInOut,
      ),
    );

    // 세 번째 애니메이션 컨트롤러
    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200), // 세 번째 이미지 애니메이션
    )..repeat(reverse: true);

    _animation3 = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _controller3,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: _buildModuleMapAppBar(context),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 100,
              ),
              SizedBox(
                height: 510,
                child: SizedBox.expand(
                  child: Image.asset(
                    "assets/images/module_map_background.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),

          // 첫 번째 움직이는 이미지
          AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              return Positioned(
                left: 150,
                top: 380 + _animation1.value,
                child: GestureDetector(
                  onTap: () {},
                  child: child,
                ),
              );
            },
            child: Image.asset(
              "assets/images/appy_levi_side.png",
              width: ImageSize.appyTiny,
            ),
          ),

          // 두 번째 움직이는 이미지
          AnimatedBuilder(
            animation: _animation2,
            builder: (context, child) {
              return Positioned(
                left: 270,
                top: 240 + _animation2.value,
                child: GestureDetector(
                  onTap: () {},
                  child: child,
                ),
              );
            },
            child: Image.asset(
              "assets/images/appy_nubi_side.png",
              width: ImageSize.appyTiny,
            ),
          ),

          // 세 번째 움직이는 이미지 (좌우 반전 포함)
          AnimatedBuilder(
            animation: _animation3,
            builder: (context, child) {
              return Positioned(
                left: 115,
                top: 150 + _animation3.value,
                child: GestureDetector(
                  onTap: () {},
                  child: Transform(
                    transform: Matrix4.identity()..scale(-1.0, 1.0),
                    child: child,
                  ),
                ),
              );
            },
            child: Image.asset(
              "assets/images/appy_bobby_side.png",
              width: ImageSize.appyTiny - 5,
            ),
          ),
        ],
      ),
    );
  }
}

AppBar _buildModuleMapAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    toolbarHeight: 70,
    centerTitle: true,
    title: const Text(
      "모듈맵",
      style: TextStyle(fontSize: TextSize.medium, fontWeight: FontWeight.w700),
    ),
    leading: Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: IconSize.medium,
            color: AppColors.icon,
          ),
        ),
      ],
    ),
  );
}
