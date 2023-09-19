import 'package:flutter/painting.dart';

DateTime now = DateTime.now();

extension DateTimeExtensions on DateTime {

  DateTime get withoutTime => DateTime(year, month, day);

  bool compareWithoutTime(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }

  // bool isInMonth(DateTime date) {
  //   return month == date.month;
  // }
  //
  // bool isToday() {
  //   return year == now.year && month == now.month && day == now.day;
  // }

  int differenceDays(DateTime date) {
    return (day - date.day).abs();
  }

  double getTopPositionIndex(int interval) =>
      (((hour * 60) + (minute)) / 60) * (60 / interval);

  String getMonthName() {
    switch (month) {
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

  String getWeekDayName() {
    switch (weekday) {
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
    return "Sunday";
  }

  bool isInList(List<DateTime> dates) {
    for(int i = 0; i < dates.length; i ++) {
      if(withoutTime.compareWithoutTime(dates[i])) {
        return true;
      }
    }
    return false;
  }
}
