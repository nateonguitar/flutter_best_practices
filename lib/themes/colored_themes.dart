import 'package:flutter/material.dart';
import 'package:flutter_best_practices/themes/core_theme.dart';
import 'package:flutter_best_practices/themes/theme_colors.dart';
import 'package:flutter_best_practices/themes/theme_generator.dart';

class LightTheme extends ThemeGenerator {
  @override
  ThemeData generate({required ThemeData baseTheme}) {
    const errorColor = Color(0xFFB83B52);
    const disabledColor = CoreTheme.greyColor;

    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: CoreTheme.lightPurpleColor,
      onPrimary: const Color(0xFFFFFFFF),
      secondary: Colors.orange,
      onSecondary: const Color(0xFFFFFFFF),
      error: errorColor,
      onError: const Color(0xFFFFFFFF),
      errorContainer: errorColor.withAlpha(25),
      onErrorContainer: CoreTheme.charcoalColor,
      surface: const Color(0xFFE6E6E6),
      onSurface: CoreTheme.charcoalColor,
    );

    final themeColors = ThemeColors(
      navBackgroundColor: CoreTheme.purpleColor,
      inputBackgroundColor: const Color(0xFFEFEFEF),
      errorContainerBackground: errorColor.withAlpha(25),
    );

    return _coloredTheme(
      baseTheme: baseTheme,
      colorScheme: colorScheme,
      themeColors: themeColors,
      disabledColor: disabledColor,
      unselectedWidgetColor: const Color(0xFFA2A3A3),
      buttonColor: CoreTheme.lightPurpleColor,
      appBarBackgroundColor: CoreTheme.darkPurpleColor,
      dividerColor: CoreTheme.lightGreyColor,
      inputBorderColor: CoreTheme.lightGreyColor,
      inputBorderColorFocused: CoreTheme.greyColor,
      inputHintColor: CoreTheme.greyColor,
      inputBackgroundColor: const Color(0xFFEFEFEF),
      dialogBackgroundColor: const Color(0xFFFFFFFF),
      cardBackgroundColor: const Color(0xFFEFEFEF),
      floatingWidgetElevation: 8,
    );
  }
}

class DarkTheme extends ThemeGenerator {
  @override
  ThemeData generate({required ThemeData baseTheme}) {
    const errorColor = Color(0xFFB83B52);

    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: CoreTheme.lightPurpleColor,
      onPrimary: const Color(0xFFE0E0E0),
      secondary: Colors.orange,
      onSecondary: const Color(0xFFE0E0E0),
      error: errorColor,
      errorContainer: errorColor.withAlpha(25),
      onErrorContainer: const Color(0xFFE0E0E0),
      onError: const Color(0xFFE0E0E0),
      surface: const Color(0xFF101010),
      onSurface: const Color(0xFFE0E0E0),
      shadow: Colors.black,
    );

    final themeColors = ThemeColors(
      navBackgroundColor: const Color.fromARGB(255, 111, 50, 151),
      inputBackgroundColor: const Color(0xFF121212),
      errorContainerBackground: errorColor.withAlpha(25),
    );

    return _coloredTheme(
      baseTheme: baseTheme,
      colorScheme: colorScheme,
      themeColors: themeColors,
      disabledColor: const Color(0xFF949393),
      unselectedWidgetColor: const Color(0xFF949393),
      buttonColor: const Color(0xFF7730B9),
      appBarBackgroundColor: CoreTheme.darkPurpleColor,
      dividerColor: const Color(0xFF686868),
      inputBorderColor: const Color(0xFF575E65),
      inputBorderColorFocused: CoreTheme.greyColor,
      inputHintColor: CoreTheme.greyColor,
      inputBackgroundColor: const Color(0xFF121212),
      dialogBackgroundColor: const Color(0xFF141414),
      cardBackgroundColor: const Color(0xFF333333),
      floatingWidgetElevation: 1,
    );
  }
}

ThemeData _coloredTheme({
  required ThemeData baseTheme,
  required ColorScheme colorScheme,
  required ThemeColors themeColors,
  required Color disabledColor,
  required Color unselectedWidgetColor,
  required Color buttonColor,
  required Color appBarBackgroundColor,
  required Color dividerColor,
  required Color inputBorderColor,
  required Color inputBorderColorFocused,
  required Color inputHintColor,
  required Color inputBackgroundColor,
  required Color dialogBackgroundColor,
  required Color cardBackgroundColor,
  required double floatingWidgetElevation,
}) {
  final popupMenuShape =
      baseTheme.popupMenuTheme.shape as RoundedRectangleBorder;
  return baseTheme.copyWith(
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    extensions: [
      themeColors,
    ],
    primaryColor: colorScheme.primary,
    disabledColor: disabledColor,
    scaffoldBackgroundColor: colorScheme.surface,
    unselectedWidgetColor: unselectedWidgetColor,
    appBarTheme: baseTheme.appBarTheme.copyWith(
      backgroundColor: appBarBackgroundColor,
      foregroundColor: colorScheme.onPrimary,
      iconTheme: IconThemeData(
        color: colorScheme.onPrimary,
      ),
    ),
    iconTheme: baseTheme.iconTheme.copyWith(
      color: colorScheme.onSurface,
    ),
    listTileTheme: baseTheme.listTileTheme.copyWith(
      textColor: colorScheme.onSurface,
      iconColor: colorScheme.primary,
      titleTextStyle: baseTheme.listTileTheme.titleTextStyle?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: baseTheme.listTileTheme.subtitleTextStyle?.copyWith(
        color: colorScheme.onSurface.withAlpha(204),
      ),
    ),
    inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
      hintStyle: baseTheme.textTheme.bodyMedium?.copyWith(
        color: inputHintColor,
      ),
      fillColor: inputBackgroundColor,
      filled: true,
      border: (baseTheme.inputDecorationTheme.border! as OutlineInputBorder)
          .copyWith(
            borderSide:
                (baseTheme.inputDecorationTheme.border! as OutlineInputBorder)
                    .borderSide
                    .copyWith(
                      color: inputBorderColor,
                    ),
          ),
      enabledBorder:
          (baseTheme.inputDecorationTheme.border! as OutlineInputBorder)
              .copyWith(
                borderSide:
                    (baseTheme.inputDecorationTheme.border!
                            as OutlineInputBorder)
                        .borderSide
                        .copyWith(
                          color: inputBorderColor,
                        ),
              ),
      focusedBorder:
          (baseTheme.inputDecorationTheme.border! as OutlineInputBorder)
              .copyWith(
                borderSide:
                    (baseTheme.inputDecorationTheme.border!
                            as OutlineInputBorder)
                        .borderSide
                        .copyWith(
                          color: inputBorderColorFocused,
                        ),
              ),
      errorBorder:
          (baseTheme.inputDecorationTheme.border! as OutlineInputBorder)
              .copyWith(
                borderSide:
                    (baseTheme.inputDecorationTheme.border!
                            as OutlineInputBorder)
                        .borderSide
                        .copyWith(
                          color: colorScheme.error,
                        ),
              ),
      focusedErrorBorder:
          (baseTheme.inputDecorationTheme.border! as OutlineInputBorder)
              .copyWith(
                borderSide:
                    (baseTheme.inputDecorationTheme.border!
                            as OutlineInputBorder)
                        .borderSide
                        .copyWith(
                          color: colorScheme.error,
                        ),
              ),
    ),

    dividerColor: dividerColor,
    dividerTheme: baseTheme.dividerTheme.copyWith(color: dividerColor),
    textTheme: baseTheme.textTheme.copyWith(
      titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      titleSmall: baseTheme.textTheme.titleSmall?.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineLarge: baseTheme.textTheme.headlineLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
      ),
      labelLarge: baseTheme.textTheme.labelLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      labelMedium: baseTheme.textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      labelSmall: baseTheme.textTheme.labelSmall?.copyWith(
        color: colorScheme.onSurface,
      ),
      bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      bodySmall: baseTheme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurface,
      ),
    ),
    bottomSheetTheme: baseTheme.bottomSheetTheme.copyWith(
      backgroundColor: colorScheme.surface,
      dragHandleColor: dividerColor,
    ),
    navigationRailTheme: baseTheme.navigationRailTheme.copyWith(
      backgroundColor: themeColors.navBackgroundColor,
      selectedIconTheme: IconThemeData(
        color: colorScheme.onPrimary,
      ),
      unselectedIconTheme: IconThemeData(
        color: unselectedWidgetColor,
      ),
      selectedLabelTextStyle: baseTheme.navigationRailTheme.selectedLabelTextStyle
          ?.copyWith(color: colorScheme.onPrimary),
      unselectedLabelTextStyle: baseTheme
          .navigationRailTheme.unselectedLabelTextStyle
          ?.copyWith(color: unselectedWidgetColor),
    ),
    bottomNavigationBarTheme: baseTheme.bottomNavigationBarTheme.copyWith(
      selectedItemColor: colorScheme.onSecondary,
      backgroundColor: themeColors.navBackgroundColor,
      selectedLabelStyle: baseTheme.bottomNavigationBarTheme.selectedLabelStyle
          ?.copyWith(color: colorScheme.onPrimary),
      unselectedLabelStyle: baseTheme
          .bottomNavigationBarTheme
          .unselectedLabelStyle
          ?.copyWith(color: unselectedWidgetColor),
    ),
    floatingActionButtonTheme: baseTheme.floatingActionButtonTheme.copyWith(
      backgroundColor: buttonColor,
      foregroundColor: colorScheme.onPrimary,
      elevation: floatingWidgetElevation,
    ),
    dialogTheme: baseTheme.dialogTheme.copyWith(
      backgroundColor: dialogBackgroundColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: baseTheme.elevatedButtonTheme.style?.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledColor;
          }
          return buttonColor;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          return colorScheme.onPrimary;
        }),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: baseTheme.textButtonTheme.style?.copyWith(
        foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledColor;
          }
          return buttonColor;
        }),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: baseTheme.outlinedButtonTheme.style!.copyWith(
        overlayColor: WidgetStateProperty.all(colorScheme.surface),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.disabled)) {
            return CoreTheme.outlinedButtonBorderSide.copyWith(
              color: disabledColor,
            );
          }
          return CoreTheme.outlinedButtonBorderSide.copyWith(
            color: buttonColor,
          );
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledColor;
          }
          return buttonColor;
        }),
      ),
    ),
    dropdownMenuTheme: baseTheme.dropdownMenuTheme.copyWith(
      menuStyle: baseTheme.dropdownMenuTheme.menuStyle?.copyWith(
        backgroundColor: WidgetStateProperty.all(colorScheme.surface),
        elevation: WidgetStateProperty.all(floatingWidgetElevation),
      ),
    ),
    cardTheme: baseTheme.cardTheme.copyWith(color: cardBackgroundColor),
    popupMenuTheme: baseTheme.popupMenuTheme.copyWith(
      color: cardBackgroundColor,
      shape: popupMenuShape.copyWith(
        side: popupMenuShape.side.copyWith(color: dividerColor),
      ),
      elevation: floatingWidgetElevation,
    ),
  );
}
