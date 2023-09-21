import 'dart:ui';

import 'base_datetime.dart';
import 'gregorian_datetime.dart';
import 'persian_datetime.dart';

class OtherFunctions {
  static BaseDateTime convertToBaseDate(String char, DateTime date) {
    switch (char) {
      case "g":
        return GregorianDateTime(date.year, date.month, date.day);
      case "p":
        return PersianDateTime(date.year, date.month, date.day);
      default:
        return BaseDateTime(date.year, date.month, date.day);
    }
  }

  static TextDirection getTextDirection(String char) {
    switch (char) {
      case "p":
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }

  static String convertToPersianNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], farsi[i]);
    }
    return input;
  }
}
