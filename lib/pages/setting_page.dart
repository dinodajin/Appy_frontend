import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Custom imports for UI components
import 'package:appy_app/icon/custom_icon_icons.dart';
import 'package:appy_app/pages/add_appy_page.dart';
import 'package:appy_app/pages/add_module_page.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/pages/login_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildSettingAppBar(context, "사용자 설정"),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddAppyPage(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      CustomIcon.fairy_wand,
                      size: IconSize.small,
                      color: AppColors.icon,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Appy 등록",
                      style: TextStyle(
                        color: AppColors.textMedium,
                        fontSize: TextSize.medium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: IconSize.medium,
                      color: AppColors.icon,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildDivider(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddModulePage(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.add_home_outlined,
                      size: IconSize.small,
                      color: AppColors.icon,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "모듈 등록",
                      style: TextStyle(
                        color: AppColors.textMedium,
                        fontSize: TextSize.medium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: IconSize.medium,
                      color: AppColors.icon,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildDivider(),
              const SizedBox(height: 20),
              _buildSettingOptionWithDialog(
                context,
                icon: Icons.logout_outlined,
                text: "로그아웃",
                message: "로그아웃 하시겠습니까?",
                confirmButtonText: "확인",
                onConfirm: () async {
                  await _logout(context);
                },
              ),
              const SizedBox(height: 20),
              _buildDivider(),
              const SizedBox(height: 20),
              _buildSettingOptionWithDialog(
                context,
                icon: Icons.waving_hand_sharp,
                text: "탈퇴하기",
                message: "정말 탈퇴하시겠습니까? \n이 작업은 되돌릴 수 없습니다.",
                confirmButtonText: "탈퇴",
                onConfirm: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text(
                        "탈퇴 완료",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textHigh,
                          fontSize: TextSize.medium,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildDivider(),
            ],
          ),
        ),
      ),
    );
  }

  // 로그아웃 API 호출
  Future<void> _logout(BuildContext context) async {
    try {
      final String apiUrl = "http://192.168.219.108:8083/api/users/logout";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // 로그아웃 성공
        Navigator.of(context).pop(); // 다이얼로그 닫기
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.primary,
            content: Text(
              "로그아웃 완료",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textHigh, fontSize: TextSize.medium),
            ),
          ),
        );

        // 로그인 화면으로 이동
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(), // LoginPage로 이동
          ),
        );
      } else {
        throw Exception('Failed to log out. Please try again.');
      }
    } catch (error) {
      Navigator.of(context).pop(); // 다이얼로그 닫기
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "로그아웃 실패: $error",
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textHigh, fontSize: TextSize.medium),
          ),
        ),
      );
    }
  }

  // 설정 옵션 위젯 + 다이얼로그 호출
  Widget _buildSettingOptionWithDialog(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String message,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return GestureDetector(
      onTap: () {
        showCustomErrorDialog(
          context: context,
          message: message,
          buttonText: confirmButtonText,
          onConfirm: onConfirm,
          cancelButtonText: "취소",
          onCancel: onCancel ?? () => Navigator.of(context).pop(),
        );
      },
      child: Row(
        children: [
          Icon(
            icon,
            size: IconSize.small,
            color: AppColors.icon,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textMedium,
              fontSize: TextSize.medium,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: IconSize.medium,
            color: AppColors.icon,
          ),
        ],
      ),
    );
  }

  // 구분선 위젯
  Widget _buildDivider() {
    return Container(
      color: AppColors.buttonDisabled,
      height: 1,
    );
  }
}
