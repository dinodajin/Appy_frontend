import 'package:appy_app/pages/home_page.dart';
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


  void _handleLogin() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // TODO: 백엔드 API 연동 필요
    // - email, password를 서버로 전송하여 인증
    // - 성공 시 응답 데이터 처리 (예: 토큰 저장)
    // - 실패 시 에러 메시지 표시

    // 예제: 이메일 및 비밀번호 확인 조건
    if (email != "registered@example.com") {
      showCustomErrorDialog(
          context: context,
          message: "등록된 이메일이 없습니다.",
          buttonText: "확인",
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
    } else if (password != "correctPassword") {
      showCustomErrorDialog(
          context: context,
          message: "비밀번호가 일치하지 않습니다.",
          buttonText: "확인",
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
    } else {
      //로그인 성공 시 페이지 이동(수정 필요!!!!!!!!!!)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(), // Replace with the desired page
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    // 화면 높이를 기준으로 키보드 상태를 반영
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: BuildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: keyboardVisible ? 75 : 300,
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
                          ? AppColors.accent
                          : AppColors.buttonDisabled,
                    ),
                    foregroundColor: _isButtonActive
                        ? AppColors.textWhite // 활성화된 텍스트 색상
                        : AppColors.textWhite, // 비활성화된 텍스트 색상
                    backgroundColor: _isButtonActive
                        ? AppColors.accent // 활성화된 배경 색상
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
      ),
    );
  }
}