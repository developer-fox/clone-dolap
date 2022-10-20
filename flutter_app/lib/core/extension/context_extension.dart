
import 'package:flutter/material.dart';

// burada tanimlanan methodlara erisebilmek icin:
//? context.<method name>
extension ContextExtension on BuildContext {
// ozellikle ekran olculerine erisebilmek icin olusturulan getter method
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}
extension ThemeExtension on BuildContext {
  ThemeData get currentThemeData => Theme.of(this);
}

extension MediaQueryExtension on BuildContext {
  // ekran yuksekligini alir
  double get height => mediaQuery.size.height;

  // ekran genisligini alir
  double get width => mediaQuery.size.width;

  double get lowValue => height * 0.01;
  double get normalValue => height * 0.02;
  double get mediumValue => height * 0.04;
  double get highValue => height * 0.1;
}

// responsive padding(all edges) extensionlari
extension PaddingExtensionAll on BuildContext {
  EdgeInsets get paddingLow => EdgeInsets.all(lowValue);
  EdgeInsets get paddingNormal => EdgeInsets.all(normalValue);
  EdgeInsets get paddingMedium => EdgeInsets.all(mediumValue);
  EdgeInsets get paddingHigh => EdgeInsets.all(highValue);
}

// responsive padding(symmetric edges) extensionlari
extension PaddingExtensionSymetric on BuildContext {
  EdgeInsets get paddingLowVertical => EdgeInsets.symmetric(vertical: lowValue);
  EdgeInsets get paddingNormalVertical =>
      EdgeInsets.symmetric(vertical: normalValue);
  EdgeInsets get paddingMediumVertical =>
      EdgeInsets.symmetric(vertical: mediumValue);
  EdgeInsets get paddingHighVertical =>
      EdgeInsets.symmetric(vertical: highValue);

  EdgeInsets get paddingLowHorizontal =>
      EdgeInsets.symmetric(horizontal: lowValue);
  EdgeInsets get paddingNormalHorizontal =>
      EdgeInsets.symmetric(horizontal: normalValue);
  EdgeInsets get paddingMediumHorizontal =>
      EdgeInsets.symmetric(horizontal: mediumValue);
  EdgeInsets get paddingHighHorizontal =>
      EdgeInsets.symmetric(horizontal: highValue);
}

extension MediaQueryExtensionDynamic on BuildContext {
  double getDynamicHeight(double percent) => height*(percent/100);
  double getDynamicWidth(double percent) => width*(percent/100);
}

// duration extensionlari
extension DurationExtension on BuildContext {
  Duration get lowDuration => const Duration(milliseconds: 500);
  Duration get normalDuration => const  Duration(seconds: 1);
}
