import 'package:flutter/material.dart';

@immutable
class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color navBackgroundColor;
  final Color inputBackgroundColor;
  final Color errorContainerBackground;

  const ThemeColors({
    required this.navBackgroundColor,
    required this.inputBackgroundColor,
    required this.errorContainerBackground,
  });

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? buttonColor,
    Color? navBackgroundColor,
    Color? inputBackgroundColor,
    Color? cardBackgroundColor,
    Color? errorContainerBackground,
  }) {
    return ThemeColors(
      navBackgroundColor: navBackgroundColor ?? this.navBackgroundColor,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      errorContainerBackground: errorContainerBackground ?? this.errorContainerBackground,
    );
  }

  @override
  ThemeExtension<ThemeColors> lerp(
    covariant ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    if (other is! ThemeColors) {
      return this;
    }
    return ThemeColors(
      navBackgroundColor:
          Color.lerp(navBackgroundColor, other.navBackgroundColor, t) ??
          Colors.transparent,
      inputBackgroundColor:
          Color.lerp(inputBackgroundColor, other.inputBackgroundColor, t) ??
          Colors.transparent,
      errorContainerBackground:
          Color.lerp(errorContainerBackground, other.errorContainerBackground, t) ??
          Colors.transparent,
    );
  }
}
