import 'dart:ui';

import 'package:custom_date_picker/core/logic/calendar_mode.dart';

import 'base_datetime.dart';
import 'gregorian_datetime.dart';
import 'persian_datetime.dart';

class OtherFunctions {
  static BaseDateTime convertToBaseDate(CalendarMode char, DateTime date) {
    switch (char) {
      case CalendarMode.GREGORIAN:
        return GregorianDateTime(date.year, date.month, date.day);
      case CalendarMode.PERSIAN:
        return PersianDateTime(date.year, date.month, date.day);
      default:
        return BaseDateTime(date.year, date.month, date.day);
    }
  }

  static TextDirection getTextDirection(CalendarMode char) {
    switch (char) {
      case CalendarMode.PERSIAN:
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
