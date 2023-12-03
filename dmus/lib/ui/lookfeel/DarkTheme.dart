
import 'package:flutter/material.dart';

import 'CommonTheme.dart';

const Color DARK1 = Color(0xff141216);
const Color DARK2 = Color(0xFF1e1b21);
const Color DARK25 = Color(0xFF242127);
const Color DARK3 = Color(0xff2e2a33); // 645375 // 241d2b
const Color DARK35 = Color(0xff3d3a42);
const Color DARK4 = Color(0xff56525b);
const Color LIGHT1 = Color(0xff913af1);
const Color LIGHT2 = Color(0xffac5bfb);


ThemeData darkTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    primary: DARK2,
    secondary: LIGHT1,
    surface: DARK3,
    background: DARK2,
    error: RED,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white10, // only seen used in Switch so far
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: DARK3
  ),
  primaryColor: DARK1,
  primaryColorLight: DARK2,
  highlightColor: LIGHT1,
  scaffoldBackgroundColor: DARK2,
  cardColor: DARK3,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: LIGHT1,
      foregroundColor: Colors.white,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: BorderSide(width: 1, color: LIGHT1.withOpacity(0.5)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      )
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: LIGHT2),
  sliderTheme: const SliderThemeData(
    activeTrackColor: LIGHT1,
    thumbColor: DARK35,
    inactiveTrackColor: DARK4,
  ),
  // https://api.flutter.dev/flutter/material/TextTheme-class.html
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w900,
      color: LIGHT1,
    ),
    displayMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w900,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w900,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
    ),
    titleLarge: TextStyle(fontSize: 18.0),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: LIGHT2,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.white,
    labelStyle: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 20.0,
    ),
    unselectedLabelStyle: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 20.0,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: Colors.white,
      )),
  appBarTheme: const AppBarTheme(
    color: DARK1,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 20.0,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: DARK1,
    selectedItemColor: LIGHT1,
    selectedLabelStyle: TextStyle(fontSize: 10.0),
    unselectedLabelStyle: TextStyle(fontSize: 10.0),
    elevation: 0.0,
  ),
  dividerTheme: const DividerThemeData(
    indent: HORIZONTAL_PADDING,
    endIndent: HORIZONTAL_PADDING,
    space: 0.0,
    color: Colors.white10,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.white30;
      }
      return DARK35;
    }),
    trackColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return LIGHT1;
      } else if (states.contains(MaterialState.disabled)) {
        return Colors.white30;
      }
      return DARK4;
    }),
  ),
  scrollbarTheme: ScrollbarThemeData(
    thickness: MaterialStateProperty.all(4.0),
    radius: const Radius.circular(2.0),
    thumbColor: MaterialStateProperty.all(Colors.white12),
    interactive: true,
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
  ),
  radioTheme: RadioThemeData(fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.white30;
      } else if (states.contains(MaterialState.selected)) {
        return LIGHT1;
      }
      return Colors.white;
    },
  )),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: DARK3,
    contentTextStyle: TextStyle(color: Colors.white70),
    closeIconColor: Colors.white,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.white30;
        } else if (states.contains(MaterialState.selected)) {
          return Colors.white30;
        }
        return Colors.white;
      },
    ),
  ),
);

