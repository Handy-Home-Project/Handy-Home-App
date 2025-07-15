import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: false,
    appBarTheme: const AppBarTheme(
      color: kWhite,
      surfaceTintColor: kTransparent,
      elevation: 0,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: kWhite,
      surfaceTintColor: kTransparent,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kWhite,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: kWhite,
      surfaceTintColor: kTransparent,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: kWhite,
      surfaceTintColor: kTransparent,
    ),
    cardTheme: const CardTheme(
      color: kWhite,
      surfaceTintColor: kTransparent,
      elevation: 0,
    ),
    fontFamily: 'Pretendard',
    textTheme: _lightTextTheme,
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: false,
    appBarTheme: const AppBarTheme(
        backgroundColor: kBlack,
        surfaceTintColor: kTransparent,
        elevation: 0
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: kBlack,
      surfaceTintColor: kTransparent,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kBlack,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: kBlack,
      surfaceTintColor: kTransparent,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: kBlack,
      surfaceTintColor: kTransparent,
    ),
    cardTheme: const CardTheme(
      color: kBlack,
      surfaceTintColor: kTransparent,
      elevation: 0,
    ),
    fontFamily: 'Pretendard',
    textTheme: _darkTextTheme,
  );

  static TextTheme get _lightTextTheme => const TextTheme(
    headlineLarge: TextStyle(
      color: kBlack,
      height: 40/34,
      fontSize: 34,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    headlineMedium: TextStyle(
      color: kBlack,
      height: 34/29,
      fontSize: 29,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    headlineSmall: TextStyle(
      color: kBlack,
      height: 28/25,
      fontSize: 25,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    titleLarge: TextStyle(
      color: kBlack,
      height: 30/23,
      fontSize: 23,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    titleMedium: TextStyle(
      color: kBlack,
      height: 22/17,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    titleSmall: TextStyle(
      color: kBlack,
      height: 20/15,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    bodyLarge: TextStyle(
      color: kBlack,
      height: 21/15,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
    bodyMedium: TextStyle(
      color: kBlack,
      height: 20/14,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
    bodySmall: TextStyle(
      color: kBlack,
      height: 18/13,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
    labelLarge: TextStyle(
      color: kBlack,
      height: 16/12,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
    labelMedium: TextStyle(
      color: kBlack,
      height: 13/11,
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
    labelSmall: TextStyle(
      color: kBlack,
      height: 10/10,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
  );

  static TextTheme get _darkTextTheme => const TextTheme(
    headlineLarge: TextStyle(
      color: kWhite,
      height: 40/34,
      fontSize: 34,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    headlineMedium: TextStyle(
      color: kWhite,
      height: 34/29,
      fontSize: 29,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    headlineSmall: TextStyle(
      color: kWhite,
      height: 28/25,
      fontSize: 25,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    titleLarge: TextStyle(
      color: kWhite,
      height: 30/23,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    titleMedium: TextStyle(
      color: kWhite,
      height: 22/17,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    titleSmall: TextStyle(
      color: kWhite,
      height: 20/15,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    bodyLarge: TextStyle(
      color: kWhite,
      height: 21/15,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
    bodyMedium: TextStyle(
      color: kWhite,
      height: 20/14,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
    bodySmall: TextStyle(
      color: kWhite,
      height: 18/13,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
    labelLarge: TextStyle(
      color: kWhite,
      height: 16/12,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
    labelMedium: TextStyle(
      color: kWhite,
      height: 13/11,
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
    labelSmall: TextStyle(
      color: kWhite,
      height: 10/10,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
  );

}