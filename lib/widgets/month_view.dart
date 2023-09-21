import 'package:custom_date_picker/core/base_datetime.dart';
import 'package:custom_date_picker/core/gregorian_datetime.dart';
import 'package:custom_date_picker/core/persian_datetime.dart';
import 'package:custom_date_picker/widgets/ui_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../all_providers.dart';
import '../provider/date_provider.dart';

class MonthView extends ConsumerStatefulWidget {
  final List<DateTime>? disableDates;
  final bool isRangeSelection;
  final String calMode;

  const MonthView({
    required this.calMode,
    required this.isRangeSelection,
    super.key,
    this.disableDates,
  });

  @override
  ConsumerState<MonthView> createState() => _RangeSelectionMonthView();
}

class _RangeSelectionMonthView extends ConsumerState<MonthView> {
  List<String> weekDayNames = [];

  // rowsNumber is the number of weeks in each month,
  // based on starting/ending weekdays.
  late int rowsNumber;

  // indexToSkip is use for starting the month,
  // for example if the first day of month is on Tuesday,
  // since our calendar first day of week is Monday,
  // we need 1 day to skip the Monday and start month days from Tue.
  // Also the skipped days will show in gray color
  late int indexToSkip;

  double cellWidth = 32;
  double cellHeight = 40;

  @override
  Widget build(BuildContext context) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    BaseDateTime firstDay = provider.currentDay.getFirstDayOfMonth();

    BaseDateTime lastDay = provider.currentDay.getLastDayOfMonth();

    indexToSkip = firstDay.weekday - 1;

    rowsNumber = ((lastDay.getDayNumber() + indexToSkip) / 7).ceil();

    setWeekDays();

    return UIPart(
      calMode: widget.calMode,
      firstDay: firstDay,
      indexToSkip: indexToSkip,
      monthName: firstDay.getMonthName(provider.currentDay.getMonth()),
      rowsNumber: rowsNumber,
      weekdays: weekDayNames,
      disableDates: widget.disableDates,
      isRangeSelection: widget.isRangeSelection,
    );
  }

  void setWeekDays() {
    if (weekDayNames.isEmpty) {
      if (widget.calMode == "p") {
        for (int i = 1; i < 8; i++) {
          weekDayNames.add(PersianDateTime.getWeekdayName(i).substring(0, 1));
        }
      } else {
        for (int i = 1; i < 8; i++) {
          weekDayNames.add(GregorianDateTime.getWeekdayName(i).substring(0, 1));
        }
      }
    }
  }
}
