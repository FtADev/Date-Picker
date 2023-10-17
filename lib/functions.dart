import 'package:flutter/material.dart';

class Functions {
  static Future onTimeTap(
    BuildContext context, {
    TimeOfDay? selected,
    Color? color,
  }) async {
    return await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      context: context,
      initialTime: selected ?? TimeOfDay(hour: DateTime.now().hour, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return TimePickerTheme(
          data: TimePickerThemeData(
            dayPeriodBorderSide: BorderSide(color: color ?? Colors.blue),
            hourMinuteColor: Colors.white,
            dayPeriodTextColor: color ?? Colors.blue,
            hourMinuteTextColor: color ?? Colors.blue,
            // dayPeriodColor: Colors.grey,
          ),
          child: child!,
        );
      },
    );
  }

  static DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
