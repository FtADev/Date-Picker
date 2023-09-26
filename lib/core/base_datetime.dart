class BaseDateTime extends DateTime {
  BaseDateTime.now() : super.now();

  BaseDateTime(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : super(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );

  String getMonthName(int index) => "";

  // static String getWeekdayName(int index) => "";

  bool isInMonth(BaseDateTime date) {
    return month == date.month;
  }

  bool isToday() =>
      year == BaseDateTime.now().year &&
      month == BaseDateTime.now().month &&
      day == BaseDateTime.now().day;

  bool compareWithoutTime(BaseDateTime date) =>
      day == date.day && month == date.month && year == date.year;

  int getDayNumber() => day;

  String getDay() => day.toString();

  int getMonth() => month;

  int getYear() => year;

  BaseDateTime getFirstDayOfMonth() => BaseDateTime.now();

  BaseDateTime getLastDayOfMonth() => BaseDateTime.now();

  BaseDateTime addDuration(int days) => BaseDateTime.now();

  BaseDateTime addMonth(int months) => BaseDateTime(year, month + months, day);

  BaseDateTime decMonth(int months) => BaseDateTime(year, month - months, day);
}
