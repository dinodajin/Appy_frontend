import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:appy_app/providers/user_provider.dart';
import 'package:appy_app/pages/add_module_appy_conn.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/widgets/qr_code_scanner.dart';

class AddModulePage extends StatefulWidget {
  const AddModulePage({super.key});

  @override
  State<AddModulePage> createState() => _AddModulePageState();
}

class _AddModulePageState extends State<AddModulePage> {
  String moduleId = ""; // 동적으로 생성된 MODULE_ID
  final String type = "TV"; // 고정 TYPE

  @override
  void initState() {
    super.initState();
    _fetchLastModuleId(); // 초기화 시 MODULE_ID 생성
  }

  Future<void> _fetchLastModuleId() async {
    final url = Uri.parse("http://43.203.220.44/:8081/api/modules/last-id");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final lastId = response.body.trim(); // 서버에서 반환된 마지막 MODULE_ID
        setState(() {
          if (lastId.isNotEmpty) {
            // 새로운 MODULE_ID 생성 (e.g., M_001 -> M_002)
            final parts = lastId.split('_');
            if (parts.length == 2) {
              final prefix = parts[0]; // "M"
              final number = int.tryParse(parts[1]) ?? 0;
              moduleId = "${prefix}_${(number + 1).toString().padLeft(3, '0')}";
            } else {
              moduleId = "M_001"; // 기본값
            }
          } else {
            moduleId = "M_001"; // 기본값
          }
        });
      } else {
        _showErrorDialog("MODULE_ID를 가져오는데 실패했습니다. 기본값 M_001을 사용합니다.");
        setState(() {
          moduleId = "M_001";
        });
      }
    } catch (e) {
      _showErrorDialog("네트워크 오류 발생: $e. 기본값 M_001을 사용합니다.");
      setState(() {
        moduleId = "M_001";
      });
    }
  }

  Future<void> _sendModuleData(String userId) async {
    final url = Uri.parse("http://43.203.220.44/:8081/api/modules/save");
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
    final userId = Provider.of<UserProvider>(context).userId;

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
                  final scannedData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrCodeScanner(),
                    ),
                  );

                  print("스캔된 데이터: $scannedData");

                  if (moduleId.isEmpty) {
                    _showErrorDialog("MODULE_ID를 생성하지 못했습니다.");
                    return;
                  }

                  // DB에 데이터 저장
                  await _sendModuleData(userId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
