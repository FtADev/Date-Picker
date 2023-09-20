import 'package:custom_date_picker/core/base_datetime.dart';
import 'package:intl/intl.dart';

class GregorianDateTime extends BaseDateTime {
  GregorianDateTime(super.year, super.month, super.day);

  GregorianDateTime.now() : super.now();

  @override
  bool isInMonth(BaseDateTime date) => month == date.month;

  @override
  bool compareWithoutTime(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }

  @override
  bool isToday() =>
      year == GregorianDateTime.now().year &&
      month == GregorianDateTime.now().month &&
      day == GregorianDateTime.now().day;

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

  @override
  String getWeekdayName(int index) {
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
