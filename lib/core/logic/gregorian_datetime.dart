import 'package:custom_date_picker/core/logic/base_datetime.dart';
import 'package:intl/intl.dart';

class GregorianDateTime extends BaseDateTime {
  GregorianDateTime(super.year, super.month, super.day);

  GregorianDateTime.now() : super.now();

  @override
  GregorianDateTime getFirstDayOfMonth() => GregorianDateTime(year, month, 1);

  @override
  GregorianDateTime getLastDayOfMonth() => GregorianDateTime(year, month + 1, 0);

  @override
  GregorianDateTime addDuration(int days) {
    DateTime date = DateTime(year, month, day);
    date = date.add(Duration(days: days));
    return GregorianDateTime(date.year, date.month, date.day);
  }

  @override
  String getMonthName(int index) {
    switch (index) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
    }
    return "";
  }

  static String getWeekdayName(int index) {
    switch (index) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
    }
    return "";
  }

  @override
  String toString() {
    String output = DateFormat.yMMMMd().format(DateTime(year, month, day));
    return output;
  }
}
