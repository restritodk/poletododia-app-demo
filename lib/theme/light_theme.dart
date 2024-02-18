import 'package:flutter/material.dart';

import '../util/styles.dart';

ThemeData light({Color color = const Color(0xFF216BAC)}) => ThemeData(
  fontFamily: 'Roboto',
  primaryColor: color,
  secondaryHeaderColor: const Color(0xFF216BAC),
  disabledColor: const Color(0xFFBABFC4),
  backgroundColor: colorBackground,
  errorColor: const Color(0xFFE84D4F),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: ColorScheme.light(primary: color, secondary: color, background: colorBackground),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
);