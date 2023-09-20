import 'package:custom_date_picker/core/base_datetime.dart';
import 'package:custom_date_picker/core/other_functions.dart';
import 'package:shamsi_date/shamsi_date.dart';

class PersianDateTime extends BaseDateTime {
  PersianDateTime(super.year, super.month, super.day);

  PersianDateTime.now() : super.now();

  @override
  bool isInMonth(BaseDateTime date) {
    Jalali first = Jalali.fromDateTime(DateTime(year, month, day));
    Jalali second = Jalali.fromDateTime(date);
    return first.month == second.month;
  }

  @override
  bool compareWithoutTime(DateTime date) {
    Jalali first = Jalali.fromDateTime(DateTime(year, month, day));
    Jalali second = Jalali.fromDateTime(date);
    return first.day == second.day &&
        first.month == second.month &&
        first.year == second.year;
  }

  @override
  bool isToday() => year == PersianDateTime.now().year &&
        month == PersianDateTime.now().month &&
        day == PersianDateTime.now().day;

  @override
  String getDay() => OtherFunctions.convertToPersianNumber(Jalali.fromDateTime(DateTime(year, month, day)).day.toString());

  @override
  int getMonth() => Jalali.fromDateTime(DateTime(year, month, day)).month;

  @override
  int getYear() => Jalali.fromDateTime(DateTime(year, month, day)).year;

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

  @override
  String toString() {
    String output = "${getYear()} ${getMonthName(getMonth())} ${getDay()}";
    output = OtherFunctions.convertToPersianNumber(output);
    return output;
  }
}