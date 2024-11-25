import 'package:flutter/material.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/widgets/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드가 나타날 때 화면 크기 조절 방지
      appBar: BuildAppBar(context),
      body: SafeArea(
        child: GestureDetector( // 화면 터치 시 키보드 숨기기
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: AppPadding.body,
            child: SingleChildScrollView(
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.accent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.accent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (text) {
                      // 이메일 입력 필드 값 변경 시 버튼 상태 업데이트
                      setState(() {});
                    },
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.accent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.accent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (text) {
                      // 비밀번호 입력 필드 값 변경 시 버튼 상태 업데이트
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 24),
                  // 로그인 버튼
                  ElevatedButton(
                    onPressed: _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
                        ? () {
                      // 로그인 성공 시 페이지 이동
                    }
                        : null, // 이메일 또는 비밀번호 입력 필드가 비어 있으면 버튼 비활성화
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fixedSize: const Size(380, 50),
                      foregroundColor: AppColors.textWhite,
                      backgroundColor: (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty)
                          ? AppColors.accent
                          : AppColors.buttonDisabled,
                    ),
                    child: const Text("로그인"),
                  ),
                  const SizedBox(height: 24),
                  // 계정이 없으신가요?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "계정이 없으신가요? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // 회원가입 페이지로 이동
                        },
                        child: const Text(
                          "회원가입",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 오류 팝업
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          title: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          titlePadding: const EdgeInsets.only(top: 30),
          contentPadding: const EdgeInsets.only(top: 10, bottom: 30),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: 130,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: TextSize.small,
                    fontFamily: "SUITE",
                  ),
                ),
                child: const Text("확인"),
              ),
            ),
          ],
        );
      },
    );
  }
}