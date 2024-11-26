import 'package:flutter/material.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/pages/login_page.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _gender;
  bool _isSignUpButtonActive = false;
  bool _isEmailChecked = false;
  // 이메일 형식 검사 함수 추가
  bool isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateSignUpButtonState);
    _passwordController.addListener(_updateSignUpButtonState);
    _nameController.addListener(_updateSignUpButtonState);
    _ageController.addListener(_updateSignUpButtonState);
  }

  void _updateSignUpButtonState() {
    setState(() {
      _isSignUpButtonActive = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _ageController.text.isNotEmpty &&
          _gender != null;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final gender = _gender;

    // 이메일 중복 확인을 했는지 검사
    if (!_isEmailChecked) {
      showCustomErrorDialog(
        context: context,
        message: "이메일이 중복 확인을 완료해주세요.",
        buttonText: "확인",
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
      return;
    }

    // 회원가입이 성공했다고 가정
    print("회원가입 정보: $email, $password, $name, $age, $gender");

    // 로그인 페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(context),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "회원가입",
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
              height: 185,
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
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
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    if (isValidEmail(email)) {
                      print("유효한 이메일 형식입니다.");
                      // TODO: 이메일 중복 확인 로직 추가
                      // - email 서버로 전송하여 인증
                      // - 성공 시 응답 데이터 처리 (예: 토큰 저장)
                      // - 실패 시 에러 메시지 표시
                      _isEmailChecked = true;
                    } else {
                      showCustomErrorDialog(
                        context: context,
                        message: "이메일 형식에 맞게 입력해주세요",
                        buttonText: "확인",
                        onConfirm: () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 14.0),
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "중복 확인",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromRGBO(127, 212, 173, 0.16),
                hintText: '비밀번호를 입력하세요',
                hintStyle: const TextStyle(color: Colors.black),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            TextField(
              controller: _nameController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromRGBO(127, 212, 173, 0.16),
                hintText: '이름을 입력하세요',
                hintStyle: const TextStyle(color: Colors.black),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(127, 212, 173, 0.16),
                      hintText: '나이를 입력하세요',
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
                ),
                const SizedBox(width: 10),
                ToggleButtons(
                  isSelected: [_gender == '남', _gender == '여'],
                  onPressed: (int index) {
                    setState(() {
                      _gender = index == 0 ? '남' : '여';
                      _updateSignUpButtonState();
                    });
                  },
                  color: AppColors.textHigh,
                  selectedColor: Colors.white,
                  fillColor: AppColors.accent,
                  borderColor: AppColors.accent,
                  borderRadius: BorderRadius.circular(8),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('남'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('여'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _isSignUpButtonActive ? _handleSignUp : null,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                fixedSize: const Size(380, 50),
                side: BorderSide(
                  color: _isSignUpButtonActive
                      ? const Color.fromRGBO(127, 212, 173, 1)
                      : AppColors.buttonDisabled,
                ),
                foregroundColor: _isSignUpButtonActive
                    ? AppColors.textWhite // 활성화된 텍스트 색상
                    : AppColors.textWhite, // 비활성화된 텍스트 색상
                backgroundColor: _isSignUpButtonActive
                    ? AppColors.accent // 활성화된 배경 색상
                    : AppColors.buttonDisabled, // 비활성화된 배경 색상
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: TextSize.small,
                  fontFamily: "SUITE",
                ),
              ),
              child: const Text("회원가입"),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // 로그인 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "계정이 있으신가요? ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "로그인",
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
    );
  }
}
