import 'package:flutter/material.dart';
import 'package:saddeeqa/core/theme/app_theme.dart';
import 'package:saddeeqa/features/game/presentation/screens/game_screen.dart';
import 'package:saddeeqa/features/rules/presentation/screens/rules_screen.dart';

void main() {
  runApp(const SaddeeqaApp());
}

class SaddeeqaApp extends StatelessWidget {
  const SaddeeqaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saddeeqa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const GameScreen(),
        '/rules': (context) => const RulesScreen(),
      },
    );
  }
}
