import 'package:flutter/material.dart';

abstract class ThemeGenerator {
  ThemeData generate({
    required ThemeData baseTheme,
  });
}