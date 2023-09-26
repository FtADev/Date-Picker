DateTime now = DateTime.now();

extension DateTimeExtensions on DateTime {
  DateTime get withoutTime => DateTime(year, month, day);

  bool compareWithoutTime(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }

  int differenceDays(DateTime date) {
    return (day - date.day).abs();
  }

  double getTopPositionIndex(int interval) =>
      (((hour * 60) + (minute)) / 60) * (60 / interval);

  bool isInList(List<DateTime> dates) {
    for (int i = 0; i < dates.length; i++) {
      if (withoutTime.compareWithoutTime(dates[i])) {
        return true;
      }
    }
    return false;
  }
}
