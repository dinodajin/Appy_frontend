import 'package:flutter/material.dart';
import 'package:appy_app/widgets/theme.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isMale = true;
  bool _isEmailChecked = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "회원가입",
                    style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // 이메일 입력
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(127, 212, 173, 0.16),
                      hintText: '이메일을 입력하세요',
                      hintStyle: const TextStyle(color: Colors.black),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.accent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: _isEmailChecked
                          ? null
                          : TextButton(
                        onPressed: () {
                          // 중복 확인 API 호출
                          setState(() {
                            _isEmailChecked = true; // 중복 확인 완료 상태로 변경
                          });
                        },
                        child: const Text(
                          "중복 확인",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      // 이메일 입력 필드 값 변경 시 버튼 상태 업데이트
                      setState(() {
                        _isEmailChecked = false; // 이메일 변경 시 중복 확인 초기화
                      });
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
                  const SizedBox(height: 16),
                  // 이름 입력
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(127, 212, 173, 0.16),
                      hintText: '이름을 입력하세요',
                      hintStyle: const TextStyle(color: Colors.black),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.accent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (text) {
                      // 이름 입력 필드 값 변경 시 버튼 상태 업데이트
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  // 나이 입력
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number, // 숫자 키보드
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(127, 212, 173, 0.16),
                      hintText: '나이를 입력하세요',
                      hintStyle: const TextStyle(color: Colors.black),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.accent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (text) {
                      // 나이 입력 필드 값 변경 시 버튼 상태 업데이트
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  // 성별 선택
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _genderToggleButton("남", _isMale),
                      _genderToggleButton("여", !_isMale),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // 회원가입 버튼
                  ElevatedButton(
                    onPressed: _emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty &&
                    _nameController.text.isNotEmpty &&
                    _ageController.text.isNotEmpty &&
                    _isEmailChecked ? () {
                      // 회원가입 처리
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fixedSize: const Size(380, 50),
                      foregroundColor: AppColors.textWhite,
                      backgroundColor: (_emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty &&
                          _nameController.text.isNotEmpty &&
                          _ageController.text.isNotEmpty &&
                          _isEmailChecked)
                          ? AppColors.accent
                          : AppColors.buttonDisabled,
                      ),
                      child: const Text("회원가입"),
                  ),
                  const SizedBox(height: 24),
                  // 계정이 있으신가요?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "계정이 있으신가요? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                        // 로그인 페이지로 이동
                        },
                        child: const Text(
                          "로그인",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 50), // 아래 여백 추가
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 성별 토글 버튼
  Widget _genderToggleButton(String gender, bool isSelected) {
    return SizedBox(
      width: 130,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isMale = (gender == "남");
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.accent : AppColors.buttonDisabled,
          foregroundColor: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: TextSize.small,
            fontFamily: "SUITE",
          ),
        ),
        child: Text(gender),
      ),
    );
  }
}