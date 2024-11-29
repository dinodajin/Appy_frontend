import 'package:appy_app/pages/add_module_appy_conn.dart';
import 'package:flutter/material.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/widgets/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddModulePage extends StatefulWidget {
  const AddModulePage({super.key});

  @override
  State<AddModulePage> createState() => _AddModulePageState();
}

class _AddModulePageState extends State<AddModulePage> {
  final String userId = "test1@gmail.com"; // 임의 USER_ID
  final String moduleId = "M001"; // 임의 MODULE_ID
  final String type = "TV"; // 임의 TYPE

  Future<void> _sendModuleData() async {
    final url = Uri.parse("http://192.168.0.54:8081/api/modules/save");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "MODULE_ID": moduleId,
      "USER_ID": userId,
      "TYPE": type,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddModuleAppyConnPage()),
        );
      } else {
        _showErrorDialog("모듈 등록 실패: ${response.body}");
      }
    } catch (e) {
      _showErrorDialog("네트워크 오류 발생: $e");
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("오류"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildSettingAppBar(context, "모듈 등록"),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 50),
              const Text(
                "모듈의 QR코드를 인식해주세요",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textHigh,
                  fontSize: TextSize.medium,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(3.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fixedSize: const Size(250, 80),
                  foregroundColor: AppColors.textWhite,
                  backgroundColor: AppColors.accent,
                  elevation: 5,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: TextSize.medium,
                    fontFamily: "SUITE",
                  ),
                ),
                child: const Text('QR코드 스캔'),
                onPressed: () async {
                  // QR 코드 스캐너 페이지 이동
                  final scannedData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrCodeScanner(),
                    ),
                  );

                  // QR 코드 스캔 결과 출력
                  print("스캔된 데이터: $scannedData");

                  // QR 코드 데이터와 관계없이 고정된 값 사용
                  const moduleId = "M001"; // 임의 값 설정
                  const type = "TV"; // 임의 값 설정

                  // DB 저장
                  await _sendModuleData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
