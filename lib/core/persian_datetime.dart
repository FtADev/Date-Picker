import 'package:custom_date_picker/core/base_datetime.dart';

class PersianDateTime extends BaseDateTime {
  PersianDateTime(super.year, super.month, super.day);
  PersianDateTime.now() : super.now();

  @override
  bool isInMonth(DateTime date) => false;

  @override
  bool isToday() => false;


  @override
  String getMonthName(int index) {
    switch (index) {
      case 1:
        return "فروردین";
      case 2:
        return "اردیبهشت";
      case 3:
        return "خرداد";
      case 4:
        return "تیر";
      case 5:
        return "مرداد";
      case 6:
        return "شهریور";
      case 7:
        return "مهر";
      case 8:
        return "آبان";
      case 9:
        return "آذر";
      case 10:
        return "دی";
      case 11:
        return "بهمن";
      case 12:
        return "اسفند";
    }
    return "";
  }

  @override
  String getWeekdayName(int index) {
    switch (index) {
      case 1:
        return "شنبه";
      case 2:
        return "یکشنبه";
      case 3:
        return "دوشنبه";
      case 4:
        return "سه‌شنبه";
      case 5:
        return "چهارشنبه";
      case 6:
        return "پنج‌شنبه";
      case 7:
        return "جمعه";
    }
    return "";
  }
}