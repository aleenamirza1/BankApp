import 'package:flutter/material.dart';

class GradientColorTheme {
  static const Color _startColor = Colors.black;
  static const Color _midColor = Color.fromARGB(137, 79, 77, 77);
  static const Color _endColor = Color.fromARGB(245, 77, 77, 79);

  static final LinearGradient linear = LinearGradient(
    colors: [_startColor, _midColor, _endColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
