import 'package:flutter/material.dart';

class DateProvider extends ChangeNotifier {
  DateTime _currentDay = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute, 0);

  DateTime get currentDay => _currentDay;

  set currentDay(DateTime value) {
    if (value != _currentDay) {
      _currentDay = value;
      notifyListeners();
    }
  }

  DateTime? _selectedDay1;

  DateTime? get selectedDay1 => _selectedDay1;

  set selectedDay1(DateTime? value) {
    debugPrint("1: $value");

    if (value != null) {
      if (_selectedDay1 == null) {
        _selectedDay1 = value;
      } else if (selectedDay1 != null && selectedDay2 != null) {
        _selectedDay1 = value;
        _selectedDay2 = null;
        clearDateRange();
      } else {
        _selectedDay1 = value; // need it for swap
      }
      addToDateRange(value);
    } else {
      _selectedDay1 = null;
    }
    notifyListeners();
  }

  DateTime? _selectedDay2;

  DateTime? get selectedDay2 => _selectedDay2;

  set selectedDay2(DateTime? value) {
    debugPrint("2: $value");

    if (value != null) {
      if (selectedDay1 != null) {
        if (value.isBefore(selectedDay1!)) {
          swapDays(value);
        } else {
          _selectedDay2 = value;
        }
        addAllDaysTill(value);
      }
    } else if (value == null) {
      _selectedDay2 = null;
    }
    notifyListeners();
  }

  void swapDays(DateTime value) {
    final swapVar = selectedDay1;
    selectedDay1 = value;
    selectedDay2 = swapVar;
  }

  List<DateTime> _rangeList = [];

  List<DateTime> get rangeList => _rangeList;

  set rangeList(List<DateTime> value) {
    if (value != _rangeList) {
      debugPrint("2: $value");
      _rangeList = value;
      notifyListeners();
    }
  }

  void addToDateRange(DateTime date) {
    rangeList.add(date);
    notifyListeners();
  }

  void clearDateRange() {
    rangeList.clear();
    notifyListeners();
  }

  void addAllDaysTill(DateTime date) {
    for (int i = 1; i <= selectedDay2!.difference(selectedDay1!).inDays; i++) {
      rangeList.add(selectedDay1!.add(Duration(days: i)));
    }
    notifyListeners();
  }

  int _currentMonth = DateTime.now().month;

  int get currentMonth => _currentMonth;

  set currentMonth(int value) {
    if (value != _currentMonth) {
      _currentMonth = value;
      notifyListeners();
    }
  }

  int _currentYear = DateTime.now().year;

  int get currentYear => _currentYear;

  set currentYear(int value) {
    if (value != _currentYear) {
      _currentYear = value;
      currentDay = DateTime(currentYear, currentMonth, currentDay.day);
      currentMonth = currentDay.month;
      notifyListeners();
    }
  }

  void nextMonth() => currentMonth++;

  void lastMonth() => currentMonth--;
}
