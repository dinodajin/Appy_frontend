import 'dart:convert';
import 'package:appy_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:appy_app/providers/user_provider.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// RFID 리스트 및 데이터
List<String> RFIDS = ["02719612895", "195307716957", "1761222116188"];
List<int> appyTypes = [0, 1, 2];
final List<String> appyNames = ["nubi", "bobby", "levi"];
final List<String> appyNamesKo = ["누비", "바비", "레비"];
final List<String> appyImages = [
  "appy_nubi.png",
  "appy_bobby.png",
  "appy_levi.png"
];

// RFID 매칭 함수
Map<String, dynamic> getCharacterData(String rfid) {
  int index = RFIDS.indexOf(rfid);
  if (index == -1) {
    return {
      "type": null,
      "name": "Unknown",
      "nameKo": "알 수 없음",
      "image": "unknown.png"
    };
  }
  return {
    "type": appyTypes[index],
    "name": appyNames[index],
    "nameKo": appyNamesKo[index],
    "image": appyImages[index],
  };
}

class AddAppyPage extends StatefulWidget {
  const AddAppyPage({super.key});

  @override
  State<AddAppyPage> createState() => _AddAppyPageState();
}

class _AddAppyPageState extends State<AddAppyPage> {
  bool _isDetected = false;
  bool isProcessing = false;
  String rfid = "";
  String characterNameKo = ""; // 캐릭터 이름 (한글)
  String characterImage = ""; // 캐릭터 이미지

  @override
  void initState() {
    super.initState();
    fetchLatestRfid();
  }

  Future<void> fetchLatestRfid() async {
    const latestUrl = "http://192.168.0.97:8083/api/module-connect/latest";

    while (!_isDetected) {
      try {
        final response = await http.get(Uri.parse(latestUrl));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            rfid = data["RFID_ID"] ?? "";
            _isDetected = rfid.isNotEmpty;
          });

          if (_isDetected) {
            final characterData = getCharacterData(rfid);
            characterNameKo = characterData["nameKo"];
            characterImage = characterData["image"];

            final userId =
                Provider.of<UserProvider>(context, listen: false).userId;
            final moduleId =
                Provider.of<UserProvider>(context, listen: false).moduleId;

            await registerRfid(moduleId);
            await registerAppy(userId, moduleId, characterData);
            await resetLatestRfid();
            print("RFID 감지 및 처리 성공: $rfid");
            return;
          }
        } else {
          print("RFID 감지 실패: ${response.statusCode}, ${response.body}");
        }
      } catch (e) {
        print("서버 요청 실패: $e");
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> resetLatestRfid() async {
    const url = "http://192.168.0.97:8083/api/module-connect/reset-latest";
    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        print("Latest RFID 초기화 완료");
      } else {
        print("초기화 실패: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("초기화 실패: $e");
    }
  }

  Future<void> registerRfid(String moduleId) async {
    const url = "http://192.168.0.97:8083/api/module-connect/rfid/register";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"RFID_ID": rfid, "MODULE_ID": moduleId}),
      );
      if (response.statusCode == 200) {
        print("RFID 등록 성공: ${response.body}");
      } else {
        print(
            "RFID 등록 실패: ${response.statusCode}, ${utf8.decode(response.bodyBytes)}");
      }
    } catch (e) {
      print("서버 요청 실패: $e");
    }
  }

  Future<void> registerAppy(String userId, String moduleId,
      Map<String, dynamic> characterData) async {
    const url = "http://192.168.0.97:8083/api/character/register";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "RFID_ID": rfid,
          "USER_ID": userId,
          "MODULE_ID": moduleId,
          "CHARACTER_TYPE": characterData["type"],
          "CHARACTER_NAME": characterData["name"],
          "GAUGE": 0,
          "SNACK_COUNT": 0,
          "CHARACTER_LEVEL": 0,
        }),
      );
      if (response.statusCode == 200) {
        print("Appy 등록 성공: ${response.body}");
      } else {
        print(
            "Appy 등록 실패: ${response.statusCode}, ${utf8.decode(response.bodyBytes)}");
      }
    } catch (e) {
      print("서버 요청 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                _isDetected ? characterNameKo : "",
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
                              "assets/images/$characterImage",
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
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: BuildButton(
                    "홈화면으로 이동하기",
                    AppColors.accent,
                    AppColors.textWhite,
                  ),
                ),
              const SizedBox(height: 130),
            ],
          ),
        ),
      ),
    );
  }
}
