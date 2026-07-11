import 'package:flutter/material.dart';

import 'CommonTheme.dart';

const Color LIGHT_THEME_LIGHT1 = Color(0xffebede9);
const Color LIGHT_THEME_LIGHT2 = Color(0xffe1e4de);
const Color LIGHT_THEME_LIGHT25 = Color(0xFFDBDED8);
const Color LIGHT_THEME_LIGHT3 = Color(0xffd1d5cc); // 645375 // 241d2b
const Color LIGHT_THEME_LIGHT35 = Color(0xffc2c5bd);
const Color LIGHT_THEME_LIGHT4 = Color(0xffa9ada4);
const Color LIGHT_THEME_DARK1 = Color(0xff6ec50e);
const Color LIGHT_THEME_DARK2 = Color(0xff53a404);

ThemeData lightTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        primary: LIGHT_THEME_LIGHT2,
        secondary: LIGHT_THEME_DARK1,
        surface: LIGHT_THEME_LIGHT3,
        error: RED,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        // only seen used in Switch so far
        onError: Colors.black,
        brightness: Brightness.light,
      ),
      primaryColor: LIGHT_THEME_LIGHT1,
      primaryColorLight: LIGHT_THEME_LIGHT2,
      highlightColor: LIGHT_THEME_DARK1,
      scaffoldBackgroundColor: LIGHT_THEME_LIGHT2,
      cardColor: LIGHT_THEME_LIGHT3,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LIGHT_THEME_DARK1,
          foregroundColor: Colors.black,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: BorderSide(width: 1, color: LIGHT_THEME_DARK1.withValues(alpha: 0.5)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        foregroundColor: Colors.black,
      )),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: LIGHT_THEME_DARK2),
      sliderTheme: const SliderThemeData(
        activeTrackColor: LIGHT_THEME_DARK1,
        thumbColor: LIGHT_THEME_LIGHT35,
        inactiveTrackColor: LIGHT_THEME_LIGHT4,
      ),
      // https://api.flutter.dev/flutter/material/TextTheme-class.html
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w900,
          color: LIGHT_THEME_DARK1,
        ),
        displayMedium: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
        displaySmall: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
        headlineMedium: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        headlineSmall: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        titleLarge: TextStyle(fontSize: 18.0),
      ),
      // selectionColor is set explicitly because the Material3 default derives it from
      // colorScheme.primary, which is the same color as scaffoldBackgroundColor here,
      // making selected text invisible
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: LIGHT_THEME_DARK2,
        selectionColor: Color(0x666EC50E),
        selectionHandleColor: LIGHT_THEME_DARK1,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Colors.black,
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
        color: Colors.black,
      ),
      iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
        foregroundColor: Colors.black,
      )),
      appBarTheme: const AppBarTheme(
        backgroundColor: LIGHT_THEME_LIGHT1,
        elevation: 0.0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 20.0,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: LIGHT_THEME_LIGHT1,
        selectedItemColor: LIGHT_THEME_DARK1,
        selectedLabelStyle: TextStyle(fontSize: 10.0),
        unselectedLabelStyle: TextStyle(fontSize: 10.0),
        elevation: 0.0,
      ),
      dividerTheme: const DividerThemeData(
        indent: HORIZONTAL_PADDING,
        endIndent: HORIZONTAL_PADDING,
        space: 0.0,
        color: Colors.black12,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.black38;
          }
          return LIGHT_THEME_LIGHT35;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return LIGHT_THEME_DARK1;
          } else if (states.contains(WidgetState.disabled)) {
            return Colors.black38;
          }
          return LIGHT_THEME_LIGHT4;
        }),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(4.0),
        radius: const Radius.circular(2.0),
        thumbColor: WidgetStateProperty.all(Colors.black12),
        interactive: true,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.black,
        contentPadding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
      ),
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.black38;
          } else if (states.contains(WidgetState.selected)) {
            return LIGHT_THEME_DARK1;
          }
          return Colors.black;
        },
      )),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: LIGHT_THEME_LIGHT3,
        contentTextStyle: TextStyle(color: Colors.black87),
        closeIconColor: Colors.black,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.black38;
            } else if (states.contains(WidgetState.selected)) {
              return LIGHT_THEME_LIGHT3;
            }
            return LIGHT_THEME_LIGHT2;
          },
        ),
      ),
    );
