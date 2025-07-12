import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_best_practices/themes/theme_generator.dart';

/// Core theme only defines values like border radiuses, font sizes, etc.
/// Override colors in the light / dark themes or any other inherited theme.
class CoreTheme extends ThemeGenerator {
  static const lightPurpleColor = Color(0xFF8D42BF);
  static const purpleColor = Color(0xFF4A0C83);
  static const darkPurpleColor = Color.fromARGB(255, 41, 13, 87);
  static const superDarkPurpleColor = Color.fromARGB(255, 21, 17, 31);

  static const superLightGreyColor = Color(0xFFF5F5F5);
  static const lightGreyColor = Color(0xFFBBBCBC);
  static const greyColor = Color(0xFF737C86);
  static const charcoalColor = Color(0xFF4F4F4F);
  static const barelyBlueGreyColor = Color(0xFF4F4F4F);
  static const residentialColor = Color(0xFF3A84AE);
  static const otherColor = Color(0xFF3B9B7A);
  static const almostBlackColor = Color(0xFF080F12);

  // This color was in the style guide but was a duplicate of almostBlackColor
  // const bluishGreyColor = Color(0xFF080F12);

  static BorderRadius get inputBorderRadius => BorderRadius.circular(4);
  static EdgeInsets get listPadding => const EdgeInsets.only(
    top: 20,
    bottom: 80,
    left: 20,
    right: 20,
  );
  static EdgeInsets get dialogTitlePadding =>
      const EdgeInsets.only(left: 20, right: 20, top: 16);
  static EdgeInsets get dialogContentPadding =>
      const EdgeInsets.symmetric(vertical: 16, horizontal: 20);

  static double get pageContentMaxWidth => 700;
  static Size get formFieldSpacing => const Size(24, 24);
  static double get infoSpacing => 8;
  static Size get betweenButtonsSpacing => const Size(8, 0);
  static EdgeInsets get pagePadding =>
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static EdgeInsets get cardSectionPadding => const EdgeInsets.all(16);
  static double get dialogMaxWidth => 512;

  static TextStyle buildStandardTextStyle() {
    return const TextStyle(fontSize: 14);
  }

  static Decoration tabBarIndicatorBuilder({required Color color}) {
    return UnderlineTabIndicator(
      borderSide: BorderSide(width: 4, color: color),
    );
  }

  static BorderSide outlinedButtonBorderSide = const BorderSide(width: 1);

  @override
  ThemeData generate({ThemeData? baseTheme}) {
    final standardTextStyle = buildStandardTextStyle();
    final inputDecorationTheme = InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      // Default border (rarely seen)
      border: OutlineInputBorder(
        borderRadius: CoreTheme.inputBorderRadius,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: CoreTheme.inputBorderRadius,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: CoreTheme.inputBorderRadius,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: CoreTheme.inputBorderRadius,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: CoreTheme.inputBorderRadius,
      ),
      labelStyle: standardTextStyle,
      hintStyle: standardTextStyle,
      errorStyle: standardTextStyle,
      helperStyle: standardTextStyle,
      prefixStyle: standardTextStyle,
      suffixStyle: standardTextStyle,
      counterStyle: standardTextStyle,
      floatingLabelStyle: standardTextStyle,
      errorMaxLines: 5,
      alignLabelWithHint: true,
    );
    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
        ),
      ),
      fontFamily: 'Poppins',
      textTheme: const TextTheme().copyWith(
        titleLarge: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: const TextStyle(fontSize: 22),
        headlineMedium: const TextStyle(fontSize: 19),
        headlineSmall: const TextStyle(fontSize: 16),
        labelLarge: const TextStyle(fontSize: 16),
        labelMedium: const TextStyle(fontSize: 14),
        labelSmall: const TextStyle(fontSize: 12),
        bodyLarge: const TextStyle(fontSize: 16),
        bodyMedium: standardTextStyle,
        bodySmall: const TextStyle(fontSize: 12),
      ),
      navigationRailTheme: NavigationRailThemeData(
        selectedLabelTextStyle: standardTextStyle,
        unselectedLabelTextStyle: standardTextStyle,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(borderRadius: inputBorderRadius),
        elevation: 8,
        clipBehavior: Clip.antiAlias,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        selectedLabelStyle: standardTextStyle,
        unselectedLabelStyle: standardTextStyle,
        type: BottomNavigationBarType.fixed,
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: inputDecorationTheme,
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(thickness: 1),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: inputDecorationTheme,
        menuStyle: MenuStyle(
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
        ),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        borderWidth: 2,
        borderRadius: inputBorderRadius,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      checkboxTheme: const CheckboxThemeData(
        side: BorderSide(width: 2),
      ),
      listTileTheme: const ListTileThemeData(
        titleTextStyle: TextStyle(fontSize: 16),
        subtitleTextStyle: TextStyle(fontSize: 13),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(),
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        applyThemeToAll: true,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontSize: 16),
          navLargeTitleTextStyle: TextStyle(fontSize: 22),
          navTitleTextStyle: TextStyle(fontSize: 18),
          navActionTextStyle: TextStyle(fontSize: 16),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
