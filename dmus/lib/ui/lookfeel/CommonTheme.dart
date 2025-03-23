import 'package:flutter/material.dart';

const Color RED = Colors.red;
const Color GREEN = Color.fromARGB(255, 61, 161, 65);

const double HORIZONTAL_PADDING = 16.0;

const double THUMB_SIZE = 56.0;

const TextStyle TEXT_HEADER = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w800,
);

const TextStyle TEXT_HEADER_S = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);

const TextStyle TEXT_BIG = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

const TextStyle TEXT_SUBTITLE = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w200,
);

const TextStyle TEXT_SMALL_HEADLINE = TextStyle(
  fontSize: 13.0,
  fontWeight: FontWeight.normal,
);

const TextStyle TEXT_SMALL_SUBTITLE = TextStyle(
  fontSize: 13.0,
  fontWeight: FontWeight.w300,
);

extension TextStyleX on TextStyle {
  /// A method to underline a text with a customizable [distance] between the text
  /// and underline. The [color], [thickness] and [style] can be set
  /// as the decorations of a [TextStyle].
  TextStyle underlined({
    Color? underlineColor,
    Color? textColor,
    double distance = 1,
    double thickness = 1,
    TextDecorationStyle style = TextDecorationStyle.solid,
  }) {
    return copyWith(
      shadows: [
        Shadow(
          color: textColor ?? (color ?? Colors.black),
          offset: Offset(0, -distance),
        )
      ],
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationThickness: thickness,
      decorationColor: underlineColor ?? color,
      decorationStyle: style,
    );
  }
}
