import 'package:efood_multivendor/util/colors.dart';
import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: pink,
  secondaryHeaderColor: Color(0xFF009f67),
  disabledColor: Color(0xffa2a7ad),
  backgroundColor: darkGrey,
  errorColor: Color(0xFFdd3135),
  brightness: Brightness.dark,
  hintColor: Color(0xFFbebebe),
  cursorColor: pink,
  cardColor: Colors.black,
  colorScheme: ColorScheme.dark(primary: pink, secondary: Color(0xFFffbd5c)),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Color(0xFFffbd5c))),
);
