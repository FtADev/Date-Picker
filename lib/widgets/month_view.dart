import 'package:custom_date_picker/core/base_datetime.dart';
import 'package:custom_date_picker/core/gregorian_datetime.dart';
import 'package:custom_date_picker/core/other_functions.dart';
import 'package:custom_date_picker/core/persian_datetime.dart';
import 'package:custom_date_picker/widgets/ui_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

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
  List<String> weekDayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

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

    BaseDateTime firstDay = OtherFunctions.convertToBaseDate(widget.calMode,
        DateTime.utc(provider.currentYear, provider.currentMonth, 1));

    BaseDateTime lastDay = OtherFunctions.convertToBaseDate(widget.calMode,
        DateTime.utc(provider.currentYear, provider.currentMonth + 1, 0));

    indexToSkip = firstDay.weekday - 1;
    rowsNumber = ((lastDay.day + indexToSkip) / 7).ceil();

    // print(firstDay);
    // for(int i=1;i<8;i++) {
    //   weekDayNames.add(DateFormat('E').format(firstDay.add(Duration(days: i))));
    // }

    return UIPart(
      calMode: widget.calMode,
      firstDay: firstDay,
      indexToSkip: indexToSkip,
      monthName: firstDay.getMonthName(firstDay.month),
      rowsNumber: rowsNumber,
      weekdays: weekDayNames,
      disableDates: widget.disableDates,
      isRangeSelection: widget.isRangeSelection,
    );
  }
}
