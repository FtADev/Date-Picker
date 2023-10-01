import 'package:custom_date_picker/core/calendar_mode.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  CalendarMode _calMode = CalendarMode.PERSIAN;

  CalendarMode get calMode => _calMode;

  set calMode(CalendarMode value) {
    if (value != _calMode) {
      _calMode = value;
      debugPrint("CalMode change to $_calMode");
      notifyListeners();
    }
  }

  bool _showRange = false;

  bool get showRange => _showRange;

  set showRange(bool value) {
    if (value != _showRange) {
      _showRange = value;
      debugPrint("RangePicker is change to $_showRange");
      notifyListeners();
    }
  }

  bool _showTime = false;

  bool get showTime => _showTime;

  set showTime(bool value) {
    if (value != _showTime) {
      _showTime = value;
      debugPrint("ShowTime is change to $_showTime");
      notifyListeners();
    }
  }

  bool _showYear = true;

  bool get showYear => _showYear;

  set showYear(bool value) {
    if (value != _showYear) {
      _showYear = value;
      debugPrint("ShowYear is change to $_showYear");
      notifyListeners();
    }
  }

}