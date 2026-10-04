import 'package:calender/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../extension/chossed_fontfamily.dart';

const MaterialColor graySwatch = MaterialColor(0XFF000000, {
  50: Color(0xFFFFFAF5),
  100: Color(0xFFFFF2E0),
  200: Color(0xFFFFE6C7),
  300: Color(0xFFFFD199),
  400: Color(0xFFFFB366),
  500: Color(0xFF241407),
  600: Color(0xFF170D05),
  700: Color(0xFF0F0803),
  800: Color(0xFF080401),
  900: Color(0xFF030100),
});
ThemeData getLightTheme({String fontFamily = ''}) {
  return _buildTheme(
    brightness: Brightness.light,
    fontFamily: fontFamily,
    baseColor: graySwatch.shade900,
    backgroundColor: AppColors.white,
    surfaceColor: AppColors.white,
    dividerColor: graySwatch.shade200,
    iconColor: graySwatch.shade600,
    navLabelColor: graySwatch.shade900,
    navUnselectedColor: graySwatch.shade600,
    overlayBrightness: Brightness.dark,
  );
}

ThemeData getDarkTheme({String fontFamily = ''}) {
  return _buildTheme(
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    baseColor: graySwatch.shade50,
    backgroundColor: graySwatch.shade900,
    surfaceColor: graySwatch.shade800,
    dividerColor: graySwatch.shade600,
    iconColor: AppColors.primaryColor,
    navLabelColor: graySwatch.shade100,
    navUnselectedColor: graySwatch.shade300,
    overlayBrightness: Brightness.light,
  );
}

ThemeData _buildTheme({
  required Brightness brightness,
  required String fontFamily,
  required Color baseColor,
  required Color backgroundColor,
  required Color surfaceColor,
  required Color dividerColor,
  required Color iconColor,
  required Color navLabelColor,
  required Color navUnselectedColor,
  required Brightness overlayBrightness,
}) {
  final alpha = fontFamily == AppFontFamily.ibmPlex.toStr ? -1.0 : 0.0;
  final textTheme = TextTheme(
    displayLarge: TextStyle(
      color: baseColor,
      fontSize: 32 + alpha,
      fontWeight: FontWeight.w600,
    ),
    displayMedium: TextStyle(
      color: baseColor,
      fontSize: 28 + alpha,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: TextStyle(
      color: baseColor,
      fontSize: 24 + alpha,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: baseColor,
      fontSize: 20 + alpha,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: baseColor,
      fontSize: 18 + alpha,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: baseColor,
      fontSize: 16 + alpha,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: baseColor,
      fontSize: 18 + alpha,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      color: baseColor,
      fontSize: 16 + alpha,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      color: baseColor,
      fontSize: 14 + alpha,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      color: baseColor,
      fontSize: 20 + alpha,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: baseColor,
      fontSize: 18 + alpha,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      color: baseColor,
      fontSize: 16 + alpha,
      fontWeight: FontWeight.w500,
    ),
    headlineLarge: TextStyle(
      color: baseColor,
      fontSize: 30 + alpha,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      color: baseColor,
      fontSize: 26 + alpha,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      color: baseColor,
      fontSize: 22 + alpha,
      fontWeight: FontWeight.w600,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: fontFamily,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    dividerColor: dividerColor,
    dividerTheme: DividerThemeData(color: dividerColor, thickness: 0.67),
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: AppColors.primaryColor,
      secondary: AppColors.primaryColor,
      surface: surfaceColor,
      error: AppColors.dangerRed,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: baseColor,
      onError: AppColors.white,
    ),
    iconTheme: IconThemeData(color: iconColor, size: 24),
    primaryIconTheme: IconThemeData(color: iconColor, size: 24),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 80,
      actionsIconTheme: IconThemeData(color: iconColor),
      iconTheme: IconThemeData(color: iconColor),
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        color: baseColor,
        fontSize: 20 + alpha,
        fontWeight: FontWeight.w700,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: overlayBrightness,
        statusBarBrightness:
            overlayBrightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarColor: baseColor,
        systemNavigationBarIconBrightness: overlayBrightness,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarDividerColor: baseColor,
        systemStatusBarContrastEnforced: false,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      elevation: 1,
      selectedLabelStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18 + alpha,
        fontWeight: FontWeight.w500,
        color: navLabelColor,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18 + alpha,
        fontWeight: FontWeight.w500,
        color: navUnselectedColor,
      ),
      selectedItemColor: navLabelColor,
      unselectedItemColor: navUnselectedColor,
      selectedIconTheme: IconThemeData(color: AppColors.primaryColor),
      unselectedIconTheme: IconThemeData(color: navUnselectedColor),
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    textTheme: textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        textStyle: TextStyle(
          fontSize: 18 + alpha,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: TextStyle(
        fontSize: 18 + alpha,
        fontFamily: fontFamily,
        color: baseColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(AppColors.primaryColor),
        textStyle: WidgetStateProperty.all<TextStyle>(
          TextStyle(
            fontSize: 18 + alpha,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      textStyle: TextStyle(
        fontSize: 18 + alpha,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      textColor: AppColors.primaryColor,
      iconColor: AppColors.primaryColor,
      collapsedIconColor: iconColor,
      collapsedTextColor: baseColor,
    ),
    datePickerTheme: DatePickerThemeData(
      weekdayStyle: TextStyle(
        fontSize: 18 + alpha + 2,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      dayStyle: TextStyle(
        fontSize: 18 + alpha + 2,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      yearStyle: TextStyle(
        fontSize: 18 + alpha + 2,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
    ),
  );
}
