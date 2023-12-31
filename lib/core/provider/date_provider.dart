import 'package:custom_date_picker/core/logic/base_datetime.dart';
import 'package:custom_date_picker/core/logic/other_functions.dart';
import 'package:flutter/material.dart';

import '../logic/calendar_mode.dart';

class DateProvider extends ChangeNotifier {
  CalendarMode _calMode = CalendarMode.GREGORIAN;

  CalendarMode get calMode => _calMode;

  set calMode(CalendarMode value) {
    if (value != _calMode) {
      _calMode = value;
      debugPrint("CalMode change to $_calMode");
      notifyListeners();
    }
  }

  BaseDateTime _currentDay = BaseDateTime.now();

  BaseDateTime get currentDay => _currentDay;

  set currentDay(BaseDateTime value) {
    if (value != _currentDay) {
      _currentDay = value;
      notifyListeners();
    }
  }

  BaseDateTime _showDay = BaseDateTime.now();

  BaseDateTime get showDay => _showDay;

  set showDay(BaseDateTime value) {
    if (value != _showDay) {
      _showDay = value;
      notifyListeners();
    }
  }


  BaseDateTime? _selectedDay1;

  BaseDateTime? get selectedDay1 => _selectedDay1;

  set selectedDay1(BaseDateTime? value) {
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

  BaseDateTime? _selectedDay2;

  BaseDateTime? get selectedDay2 => _selectedDay2;

  set selectedDay2(BaseDateTime? value) {
    debugPrint("2: $value");

    if (value != null) {
      if (selectedDay1 != null) {
        if (value.isBefore(selectedDay1!)) {
          _swapDays(value);
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

  void _swapDays(BaseDateTime value) {
    final swapVar = selectedDay1;
    selectedDay1 = value;
    selectedDay2 = swapVar;
  }

  List<BaseDateTime> _rangeList = [];

  List<BaseDateTime> get rangeList => _rangeList;

  set rangeList(List<BaseDateTime> value) {
    if (value != _rangeList) {
      debugPrint("2: $value");
      _rangeList = value;
      notifyListeners();
    }
  }

  void addToDateRange(BaseDateTime date) {
    rangeList.add(date);
    notifyListeners();
  }

  void clearDateRange() {
    rangeList.clear();
    notifyListeners();
  }

  void addAllDaysTill(BaseDateTime date) {
    for (int i = 1; i <= selectedDay2!.difference(selectedDay1!).inDays; i++) {
      rangeList.add(OtherFunctions.convertToBaseDate(
          calMode, selectedDay1!.add(Duration(days: i))));
    }
    notifyListeners();
  }

  // int _currentMonth = BaseDateTime.now().month;
  //
  // int get currentMonth => _currentMonth;
  //
  // set currentMonth(int value) {
  //   if (value != _currentMonth) {
  //     _currentMonth = value;
  //     showDay = BaseDateTime(showDay.year, value, showDay.day);
  //     notifyListeners();
  //   }
  // }

  int _currentYear = BaseDateTime.now().year;

  int get currentYear => _currentYear;

  set currentYear(int value) {
    if (value != _currentYear) {
      _currentYear = value;
      showDay = BaseDateTime(value, showDay.month, showDay.day);
      // currentMonth = currentDay.month;
      notifyListeners();
    }
  }

  void nextMonth() => showDay = showDay.addMonth(1);

  void lastMonth() => showDay = showDay.subMonth(1);
}
