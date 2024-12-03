import 'dart:math';
import 'dart:convert';
import 'package:appy_app/pages/module_map_page.dart';
import 'package:appy_app/pages/setting_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:appy_app/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _topAnimations = [];
  final List<Animation<double>> _leftAnimations = [];
  final Random _random = Random();
  final List<Map<String, double>> _startPositions = [
    {"top": 300, "left": 150},
    {"top": 200, "left": 100},
    {"top": 350, "left": 200},
  ];
  bool _isLoading = true;
  List<Map<String, dynamic>> _registeredItems = [];

  final List<int> durations = [1500, 1800, 1800];
  final double topMin = 200;
  final double topMax = 400;
  late double leftMin = 20;
  late double leftMax = 300;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<List<Map<String, dynamic>>> fetchUserRfids(String userId) async {
    const String baseUrl = "http://192.168.0.54:8083/api/character/user-rfids";
    final Uri uri = Uri.parse("$baseUrl?userId=$userId");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception("Failed to fetch RFIDs. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching RFIDs: $e");
    }
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await Future.delayed(const Duration(milliseconds: 500));
    String userId = userProvider.userId;

    try {
      List<Map<String, dynamic>> rfids = await fetchUserRfids(userId);
      for (int i = 0; i < rfids.length; i++) {
        _startPositions.add({
          "top": _random.nextDouble() * (topMax - topMin) + topMin,
          "left": _random.nextDouble() * (leftMax - leftMin) + leftMin,
        });
      }

      setState(() {
        _registeredItems = rfids;
        _isLoading = false;
      });

      _initAnimations();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching RFIDs: $e");
    }
  }

  void _initAnimations() {
    for (var i = 0; i < _registeredItems.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durations[i % durations.length]),
      );

      _controllers.add(controller);

      _setNewAnimationValues(i);

      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _setNewAnimationValues(i);
          controller.forward(from: 0);
        }
      });

      controller.forward();
    }
  }

  void _setNewAnimationValues(int index) {
    final startTop =
        (index < _topAnimations.length && _topAnimations[index] != null)
            ? _topAnimations[index].value
            : _startPositions[index]["top"]!;
    final startLeft =
        (index < _leftAnimations.length && _leftAnimations[index] != null)
            ? _leftAnimations[index].value
            : _startPositions[index]["left"]!;

    double newTop = startTop + _random.nextInt(200) - 100;
    double newLeft = startLeft + _random.nextInt(200) - 100;

    if (newTop <= topMin || newTop >= topMax) {
      newTop += _random.nextInt(30) * (_random.nextBool() ? 1 : -1);
    }
    if (newLeft <= leftMin || newLeft >= leftMax) {
      newLeft += _random.nextInt(30) * (_random.nextBool() ? 1 : -1);
    }

    newTop = newTop.clamp(topMin, topMax);
    newLeft = newLeft.clamp(leftMin, leftMax);

    setState(() {
      if (index < _topAnimations.length) {
        _topAnimations[index] = Tween<double>(begin: startTop, end: newTop)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(_controllers[index]);
        _leftAnimations[index] = Tween<double>(begin: startLeft, end: newLeft)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(_controllers[index]);
      } else {
        _topAnimations.add(Tween<double>(begin: startTop, end: newTop)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(_controllers[index]));
        _leftAnimations.add(Tween<double>(begin: startLeft, end: newLeft)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(_controllers[index]));
      }
      
      // 새로운 시작 위치 업데이트
      _startPositions[index]["top"] = newTop;
      _startPositions[index]["left"] = newLeft;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.homeBackground,
    appBar: _buildHomeAppBar(context),
    body: Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            "assets/images/home_background.png",
            fit: BoxFit.cover,
          ),
        ),
        // 로딩 표시
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else
          // 등록된 아이템 표시
          ..._registeredItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return AnimatedBuilder(
              animation: _controllers[index],
              builder: (context, child) {
                print("Screen Size: ${MediaQuery.of(context).size.width}x${MediaQuery.of(context).size.height}");

                print("Item ${item['characterName']}: top=${_topAnimations[index].value}, left=${_leftAnimations[index].value}");

                return Positioned(
                  top: _topAnimations[index].value,
                  left: _leftAnimations[index].value,
                  child: GestureDetector(
                    onTap: () {
                      print("Tapped on RFID: ${item['RFID']}");
                    },
                    child: Image.asset(
                      "assets/images/appy_${item['characterName']}.png", // 캐릭터 이미지
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                      print("Error loading image: ${item['characterName']}");
                      return Icon(Icons.error, size: 100, color: Colors.red);
                    },
                    ),
                  ),
                );
              },
            );
          }).toList(),
      ],
    ),
  );
}
}

AppBar _buildHomeAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    toolbarHeight: 70,
    centerTitle: true,
    leading: IconButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ModuleMapPage()));
        },
        icon: const Icon(
          Icons.map,
          size: IconSize.medium,
          color: AppColors.icon,
        )),
    actions: [
      IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingPage()));
          },
          icon: const Icon(
            Icons.settings,
            size: IconSize.medium,
            color: AppColors.icon,
          ))
    ],
  );
}
