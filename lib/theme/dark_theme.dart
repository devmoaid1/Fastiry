import 'package:efood_multivendor/util/colors.dart';
import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: Color(0xFFCC293D),
  secondaryHeaderColor: Color(0xFF009f67),
  disabledColor: Color.fromARGB(255, 192, 196, 201),
  backgroundColor: darkGrey,
  errorColor: Color(0xFFdd3135),
  brightness: Brightness.dark,
  hintColor: Color(0xFFbebebe),
  dividerColor: Color.fromARGB(229, 244, 240, 240),
  cardColor: Color.fromARGB(255, 50, 48, 48),
  bottomAppBarColor: Color.fromARGB(255, 50, 48, 48),
  colorScheme: ColorScheme.dark(
      primary: Color(0xFFCC293D), secondary: Color(0xFFffbd5c)),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Color(0xFFCC293D))),
  textSelectionTheme: TextSelectionThemeData(cursorColor: pink),
);
