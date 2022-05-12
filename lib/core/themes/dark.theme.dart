import 'package:default_themes/core/themes/colors.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _colorScheme = const ColorScheme(
  primary: CustomColors.pink,
  primaryVariant: CustomColors.pink,
  secondary: CustomColors.pink,
  secondaryVariant: CustomColors.pink,
  surface: CustomColors.blackColor,
  background: CustomColors.blackColor,
  error: CustomColors.darkPink,
  onPrimary: CustomColors.blackColor,
  onSecondary: CustomColors.blackColor,
  onSurface: CustomColors.silverColor,
  onBackground: CustomColors.silverColor,
  onError: CustomColors.silverColor,
  brightness: Brightness.dark,
);

Color _getCheckboxCheckedColor(Set<MaterialState> states) {
  if (!states.contains(MaterialState.disabled)) {
    return CustomColors.blackColor;
  }
  return CustomColors.blackColor;
}

Color _getCheckboxFillColor(Set<MaterialState> states) {
  if (!states.contains(MaterialState.disabled)) {
    return CustomColors.pink;
  }
  return CustomColors.darkenedSilverColor;
}

Color _getSwitchTrackColor(Set<MaterialState> states) {
  if (states.contains(MaterialState.disabled)) {
    return CustomColors.silverColor;
  } else if (states.contains(MaterialState.selected)) {
    return CustomColors.lightPink;
  }

  return CustomColors.darkSilverColor;
}

Color _getSwitchThumbColor(Set<MaterialState> states) {
  if (states.contains(MaterialState.disabled)) {
    return CustomColors.darkenedSilverColor;
  } else if (states.contains(MaterialState.selected)) {
    return CustomColors.pink;
  }

  return CustomColors.silverColor;
}

Color _getRadioFillColor(Set<MaterialState> states) {
  if (!states.contains(MaterialState.disabled)) {
    return CustomColors.pink;
  }
  return CustomColors.darkenedSilverColor;
}

BorderSide _getOutlinedColor(Set<MaterialState> states) {
  if (!states.contains(MaterialState.disabled)) {
    return const BorderSide(color: CustomColors.pink);
  }
  return const BorderSide(color: CustomColors.darkenedSilverColor);
}

ThemeData getDarkTheme(BuildContext context) {
  final textTheme = Typography.material2018(platform: defaultTargetPlatform).white;

  final buttonScaledPadding = ButtonStyleButton.scaledPadding(
    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
    MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
  );

  final textButtonScaledPadding = ButtonStyleButton.scaledPadding(
    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
  );

  return ThemeData.from(
    colorScheme: _colorScheme,
    textTheme: textTheme.apply(fontFamily: 'FF Mark'),
  ).copyWith(
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: CustomColors.pink,
        padding: textButtonScaledPadding,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: CustomColors.pink,
        onPrimary: CustomColors.lightSilverColor,
        padding: buttonScaledPadding,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: CustomColors.pink,
        padding: buttonScaledPadding,
      ).copyWith(
        side: MaterialStateProperty.resolveWith(_getOutlinedColor),
      ),
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: CustomColors.blackColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: CustomColors.blackColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((_getCheckboxFillColor)),
      checkColor: MaterialStateProperty.resolveWith(_getCheckboxCheckedColor),
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith(_getSwitchTrackColor),
      thumbColor: MaterialStateProperty.resolveWith(_getSwitchThumbColor),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith(_getRadioFillColor),
    ),
  );
}