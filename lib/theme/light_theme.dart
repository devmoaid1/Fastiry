import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/colors.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.poppins,
  primaryColor: Color(0xFFCC293D),
  secondaryHeaderColor: Color(0xFF1ED7AA),
  disabledColor: lightGreyTextColor.withOpacity(0.7),
  dividerColor: lightGreyTextColor,
  backgroundColor: Color(0xFFFFFFFF),
  errorColor: Color(0xFFE84D4F),
  brightness: Brightness.light,
  hintColor: Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Color(0xFFCC293D),
    secondary: Color(0xFFEF7822),
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Color(0xFFCC293D))),
);
