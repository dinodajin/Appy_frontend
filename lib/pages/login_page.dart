import 'package:flutter/material.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonActive = false; // 버튼 활성화 상태

  @override
  void initState() {
    super.initState();
    // 입력 필드 변화 감지
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonActive = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: AppColors.textLight,
          contentPadding: const EdgeInsets.all(10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 35),
              Text(message, textAlign : TextAlign.center, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF66CFA3),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                minimumSize: const Size(100,30),
              ),
              child: const Text("확인"),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  void _handleLogin() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // TODO: 백엔드 API 연동 필요
    // - email, password를 서버로 전송하여 인증
    // - 성공 시 응답 데이터 처리 (예: 토큰 저장)
    // - 실패 시 에러 메시지 표시

    // 예제: 이메일 및 비밀번호 확인 조건
    if (email != "registered@example.com") {
      _showErrorDialog("등록된 이메일이 없습니다");
    } else if (password != "correctPassword") {
      _showErrorDialog("비밀번호가 일치하지 않습니다");
    } else {
      // 로그인 성공 시 페이지 이동(수정 필요!!!!!!!!!!)
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const SignUpPage(), // Replace with the desired page
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.body,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "로그인",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    width: 5,
                  ),
                ],
              ),
              Container(
                height: 300,
              ),
              // 이메일 입력
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(127, 212, 173, 0.16),
                  hintText: '이메일을 입력하세요',
                  hintStyle: const TextStyle(color: Colors.black),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 비밀번호 입력
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(127, 212, 173, 0.16),
                  hintText: '비밀번호를 입력하세요',
                  hintStyle: const TextStyle(color: Colors.black),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 로그인 버튼
              OutlinedButton(
                onPressed: _isButtonActive ? _handleLogin : null,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fixedSize: const Size(380, 50),
                  side: BorderSide(
                    color: _isButtonActive
                        ? const Color.fromRGBO(127, 212, 173, 1)
                        : AppColors.buttonDisabled,
                  ),
                  foregroundColor: _isButtonActive
                      ? AppColors.textWhite // 활성화된 텍스트 색상
                      : AppColors.textWhite, // 비활성화된 텍스트 색상
                  backgroundColor: _isButtonActive
                      ? const Color.fromRGBO(127, 212, 173, 1) // 활성화된 배경 색상
                      : AppColors.buttonDisabled, // 비활성화된 배경 색상
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: TextSize.small,
                    fontFamily: "SUITE",
                  ),
                ),
                child: const Text("로그인"),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  // 회원가입 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "계정이 없으신가요? ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "회원가입",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}