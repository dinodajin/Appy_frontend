import 'package:flutter/material.dart';
import 'package:appy_app/widgets/theme.dart';
import 'package:appy_app/widgets/widget.dart';
import 'package:appy_app/pages/login_page.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  bool _isEmailAvailable = true;

  // 이메일 형식 검사 함수
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
          _gender != null &&
          (!_isEmailChecked || _isEmailAvailable);
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

  void _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final gender = _gender;

    // 이메일 중복 확인 여부 검사
    if (!_isEmailChecked) {
      showCustomErrorDialog(
        context: context,
        message: "이메일 중복 확인을 완료해주세요.",
        buttonText: "확인",
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
      return;
    }

    final url = Uri.parse("http://192.168.0.54:8083/api/users");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "USER_ID": email,
      "USER_PW": password,
      "NAME": name,
      "AGE": int.tryParse(age),
      "GENDER": gender,
      "CREATED_AT": DateTime.now().toIso8601String(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // 회원가입 성공 처리
        print("회원가입 성공: ${response.body}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // 에러 처리
        final responseData = jsonDecode(response.body);
        showCustomErrorDialog(
          context: context,
          message: responseData['message'] ?? '회원가입 중 오류가 발생했습니다.',
          buttonText: "확인",
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      }
    } catch (e) {
      // 네트워크 에러 처리
      print("네트워크 에러: $e");
      showCustomErrorDialog(
        context: context,
        message: "서버와 연결할 수 없습니다. 인터넷 연결을 확인해주세요.",
        buttonText: "확인",
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 화면 높이를 기준으로 키보드 상태를 반영
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: BuildAppBar(context),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: AppPadding.body,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "회원가입",
                    style: TextStyle(
                      fontSize: TextSize.huge,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(width: 5),
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: keyboardVisible ? 40 : 185,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _isEmailAvailable
                            ? AppColors.accent.withOpacity(0.16)
                            : AppColors.caution.withOpacity(0.16),
                        hintText: '이메일을 입력하세요',
                        hintStyle: const TextStyle(color: Colors.black),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.accent),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.accent, width: 2.0),
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

                        final checkUrl = Uri.parse(
                            "http://192.168.0.54:8083/api/users/check/$email");
                        final headers = {"Content-Type": "application/json"};

                        try {
                          final response =
                              await http.get(checkUrl, headers: headers);

                          if (response.statusCode == 200) {
                            setState(() {
                              _isEmailChecked = true;
                              _isEmailAvailable = true;
                            });
                            _updateSignUpButtonState(); // 즉시 버튼 상태 업데이트
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 1),
                                backgroundColor: AppColors.primary,
                                content: Center(
                                  child: Text(
                                    "사용 가능한 이메일입니다.",
                                    style: TextStyle(
                                      color: AppColors.textHigh,
                                      fontSize: TextSize.small,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (response.statusCode == 400) {
                            setState(() {
                              _isEmailChecked = true;
                              _isEmailAvailable = false;
                            });
                            _updateSignUpButtonState(); // 즉시 버튼 상태 업데이트
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 1),
                                backgroundColor: AppColors.primary,
                                content: Center(
                                  child: Text(
                                    "이미 등록된 이메일입니다.",
                                    style: TextStyle(
                                      color: AppColors.textHigh,
                                      fontSize: TextSize.small,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            showCustomErrorDialog(
                              context: context,
                              message: "이메일 중복 확인 중 오류가 발생했습니다.",
                              buttonText: "확인",
                              onConfirm: () {
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        } catch (e) {
                          print("네트워크 에러: $e");
                          showCustomErrorDialog(
                            context: context,
                            message: "서버와 연결할 수 없습니다.",
                            buttonText: "확인",
                            onConfirm: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      } else {
                        showCustomErrorDialog(
                          context: context,
                          message: "이메일 형식에 맞게 입력해주세요.",
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
                  fillColor: AppColors.accent.withOpacity(0.16),
                  hintText: '비밀번호를 입력하세요',
                  hintStyle: const TextStyle(color: Colors.black),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.accent, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.accent.withOpacity(0.16),
                  hintText: '이름을 입력하세요',
                  hintStyle: const TextStyle(color: Colors.black),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.accent, width: 2.0),
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
                        fillColor: AppColors.accent.withOpacity(0.16),
                        hintText: '나이를 입력하세요',
                        hintStyle: const TextStyle(color: Colors.black),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.accent),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.accent, width: 2.0),
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
                onPressed: _isSignUpButtonActive && _isEmailAvailable
                    ? _handleSignUp
                    : null,
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
                      ? AppColors.textWhite
                      : AppColors.textWhite,
                  backgroundColor: _isSignUpButtonActive
                      ? AppColors.accent
                      : AppColors.buttonDisabled,
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
                        color: AppColors.textMedium,
                        fontSize: TextSize.small,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "로그인",
                      style: TextStyle(
                        color: AppColors.textHigh,
                        fontSize: TextSize.small,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
