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
  bool isToday() =>
      year == PersianDateTime.now().year &&
      month == PersianDateTime.now().month &&
      day == PersianDateTime.now().day;

  @override
  String getDay() => OtherFunctions.convertToPersianNumber(
      Jalali.fromDateTime(DateTime(year, month, day)).day.toString());

  @override
  int getDayNumber() => Jalali.fromDateTime(DateTime(year, month, day)).day;

  @override
  int getMonth() => Jalali.fromDateTime(DateTime(year, month, day)).month;

  @override
  int getYear() => Jalali.fromDateTime(DateTime(year, month, day)).year;

  @override
  PersianDateTime getFirstDayOfMonth() {
    Jalali j = Jalali.fromDateTime(DateTime(year, month, day));
    Jalali firstDay = j.withDay(1);
    DateTime utc = firstDay.toUtcDateTime();
    PersianDateTime output = PersianDateTime(utc.year, utc.month, utc.day);
    return output;
  }

  @override
  PersianDateTime getLastDayOfMonth() {
    Jalali j = Jalali.fromDateTime(DateTime(year, month, day));
    Jalali firstDay = j.withDay(j.monthLength);
    DateTime utc = firstDay.toUtcDateTime();
    PersianDateTime output = PersianDateTime(utc.year, utc.month, utc.day);
    return output;
  }

  @override
  PersianDateTime addDuration(int days) {
    // Jalali j = Jalali.fromDateTime(DateTime(year, month, day));
    // Jalali nextDay = j.withDay(days);
    // print(nextDay);
    return PersianDateTime(year, month, day + days);
  }

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

  static String getWeekdayName(int index) {
    switch (index) {
      case 1:
        return "دوشنبه";
      case 2:
        return "سه‌شنبه";
      case 3:
        return "چهارشنبه";
      case 4:
        return "پنج‌شنبه";
      case 5:
        return "جمعه";
      case 6:
        return "شنبه";
      case 7:
        return "یکشنبه";
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
