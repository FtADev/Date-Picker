import 'package:shamsi_date/shamsi_date.dart';

import 'base_datetime.dart';
import 'gregorian_datetime.dart';
import 'persian_datetime.dart';

class OtherFunctions {
  static BaseDateTime convertToBaseDate(String char, DateTime date) {
    switch (char) {
      case "g":
        return GregorianDateTime(date.year, date.month, date.day);
      case "p":
        return convertToPersian(date);
      default:
        return BaseDateTime(date.year, date.month, date.day);
    }
  }

  static BaseDateTime convertToPersian(DateTime date) {
    Jalali j = Jalali.fromDateTime(date);
    int year = j.year;
    int month = j.month;
    int day = j.day;
    return PersianDateTime(year, month, day);
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