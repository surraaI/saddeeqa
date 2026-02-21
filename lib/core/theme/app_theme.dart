import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(AppColors.background),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(AppColors.boardBase),
          foregroundColor: Color(AppColors.active),
          elevation: 0,
        ),
      );
}
