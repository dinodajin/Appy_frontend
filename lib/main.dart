import 'package:appy_app/pages/add_appy_page.dart';
import 'package:appy_app/pages/add_module_appy_conn.dart';
import 'package:appy_app/pages/add_module_page.dart';
import 'package:appy_app/pages/chat_page.dart';
import 'package:appy_app/pages/home_page.dart';
import 'package:appy_app/pages/module_map_page.dart';
import 'package:appy_app/pages/onboarding_page.dart';
import 'package:appy_app/pages/start_page.dart';
import 'package:appy_app/providers/user_provider.dart'; // UserProvider 추가
import 'package:appy_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider 패키지 추가

void main() {
  runApp(const AppyApp());
}

class AppyApp extends StatelessWidget {
  const AppyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider()), // UserProvider 등록
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "SUITE",
          primaryColor: AppColors.primary,
          highlightColor: AppColors.accent,
          scaffoldBackgroundColor: AppColors.background,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: AppColors.textHigh),
          ),
        ),
        home: const OnboardingPage(),
        // home: HomePage(),
      ),
    );
  }
}
