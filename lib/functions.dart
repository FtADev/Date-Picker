import 'package:flutter/material.dart';

import 'core/app_colors.dart';

class Functions {

  static Future onTimeTap(BuildContext context, {TimeOfDay? selected}) async {
    return await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      context: context,
      initialTime: selected ?? TimeOfDay(hour: DateTime.now().hour, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return TimePickerTheme(
          data: const TimePickerThemeData(
            dayPeriodBorderSide: BorderSide(color: AppColor.pinkColor),
            hourMinuteColor: Colors.white,
            dayPeriodTextColor: AppColor.pinkColor,
            hourMinuteTextColor: AppColor.pinkColor,
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
