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

  String getWeekdayName(int index) => "";

  bool isInMonth(BaseDateTime date) => false;

  bool isToday() => false;

  bool compareWithoutTime(BaseDateTime date) => false;

  String getDayNumber(BaseDateTime date) => "";
}
