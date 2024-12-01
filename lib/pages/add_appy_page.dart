import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:appy_app/providers/user_provider.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddAppyPage extends StatefulWidget {
  const AddAppyPage({super.key});

  @override
  State<AddAppyPage> createState() => _AddAppyPageState();
}

class _AddAppyPageState extends State<AddAppyPage> {
  bool _isDetected = false; // RFID 인식 여부
  String rfid = "RFID001"; // 수정필요: 임시 RFID 값
  String characterName = "레비"; // 기본 캐릭터 이름
  int characterType = 0; // 기본 캐릭터 타입

  Future<void> _registerAppy(String userId) async {
  // final checkConnectUrl = Uri.parse("http://43.203.220.44:8082/api/module-connect/save");
    final url = Uri.parse("http://43.203.220.44:8082/api/character/register");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "RFID_ID": rfid,
      "USER_ID": userId,
      "CHARACTER_TYPE": characterType,
      "CHARACTER_NAME": characterName,
      "GAUGE": 0,
      "SNACK_COUNT": 0,
      "CHARACTER_LEVEL": 0,
    });

    print("Sending request to $url with body: $body"); // 요청 디버깅용 로그 추가
    
    try {
  final response = await http.post(url, headers: headers, body: body);
  print("Request URL: $url");
  print("Request Body: $body");
  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    _showSnackBar("새로운 Appy가 등록되었습니다!", Colors.green);
  } else if (response.statusCode == 409) {
    _showSnackBar("이미 등록된 Appy입니다.", Colors.red);
  } else {
    _showSnackBar("Appy 등록에 실패했습니다: ${response.body}", Colors.red);
  }
} catch (e) {
  print("Network Error: $e");
  _showSnackBar("네트워크 오류 발생: $e", Colors.red);
}
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 2초 후 RFID 감지 상태 변경
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isDetected = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context).userId;

    return Scaffold(
      appBar: BuildSettingAppBar(context, "Appy 등록"),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                _isDetected ? characterName : "",
                style: const TextStyle(
                  color: AppColors.textMedium,
                  fontSize: TextSize.medium,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: AppColors.buttonDisabled,
                height: _isDetected ? 1 : 0,
              ),
              Expanded(
                child: Center(
                  child: _isDetected
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/appy_levi.png",
                              height: 300,
                            ),
                            const Text(
                              "Appy가 등록되었습니다!",
                              style: TextStyle(
                                color: AppColors.textHigh,
                                fontSize: TextSize.medium,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SpinKitChasingDots(
                              color: AppColors.accent,
                              size: 50.0,
                              duration: Duration(seconds: 2),
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Appy를 찾는 중입니다...",
                              style: TextStyle(
                                color: AppColors.textHigh,
                                fontSize: TextSize.medium,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              if (_isDetected)
                GestureDetector(
                  onTap: () => _registerAppy(userId),
                  child: BuildButton(
                      "Appy 등록하기",
                      AppColors.accent, // 활성화 색상
                      AppColors.textWhite),
                ),
              const SizedBox(height: 130),
            ],
          ),
        ),
      ),
    );
  }
}
