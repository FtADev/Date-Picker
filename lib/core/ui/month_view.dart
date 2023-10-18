import 'package:custom_date_picker/core/logic/base_datetime.dart';
import 'package:custom_date_picker/core/logic/calendar_mode.dart';
import 'package:custom_date_picker/core/logic/gregorian_datetime.dart';
import 'package:custom_date_picker/core/logic/other_functions.dart';
import 'package:custom_date_picker/core/logic/persian_datetime.dart';
import 'package:custom_date_picker/core/ui/main_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../all_providers.dart';
import '../provider/date_provider.dart';

class MonthView extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final List<DateTime>? disableDates;
  final bool isRangeSelection;
  final CalendarMode calMode;
  final Color? primaryColor;
  final Color? secondaryColor;

  final Function? onDaysSelected;

  /// Example:
  /// onDaysSelected(List<BaseDateTime?> days) {
  //      selectedDay1 = days[0]; //for both single & range selection
  //
  //      if (widget.showRange) {
  //        selectedDay2 = days[1];
  //      }
  //    }

  const MonthView({
    this.onDaysSelected,
    this.initialDate,
    this.primaryColor,
    this.secondaryColor,
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

  // late TimeOfDay selectedTime;
  // late TimeOfDay selectedTime1;
  // late TimeOfDay selectedTime2;

  @override
  void initState() {
    DateTime? initialDate = widget.initialDate ?? BaseDateTime.now();

    // selectedTime =
    //     TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);
    // selectedTime1 =
    //     TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);
    // selectedTime2 =
    //     TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DateProvider provider = ref.watch(AllProvider.dateProvider);

      provider.calMode = widget.calMode;
      provider.currentDay =
          OtherFunctions.convertToBaseDate(widget.calMode, initialDate);
      provider.showDay =
          OtherFunctions.convertToBaseDate(widget.calMode, initialDate);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    DateTime currentDate = DateTime(
        provider.showDay.year, provider.showDay.month, provider.showDay.day);
    BaseDateTime currentBasedDate =
        OtherFunctions.convertToBaseDate(widget.calMode, currentDate);
    BaseDateTime firstDay = currentBasedDate.getFirstDayOfMonth();

    BaseDateTime lastDay = currentBasedDate.getLastDayOfMonth();

    indexToSkip = firstDay.weekday - 1;

    rowsNumber = ((lastDay.getDayNumber() + indexToSkip) / 7).ceil();

    setWeekDays();

    return MainPart(
      calMode: widget.calMode,
      firstDay: firstDay,
      indexToSkip: indexToSkip,
      monthName: firstDay.getMonthName(firstDay.getMonth()),
      rowsNumber: rowsNumber,
      weekdays: weekDayNames,
      disableDates: widget.disableDates,
      isRangeSelection: widget.isRangeSelection,
      primaryColor: widget.primaryColor,
      secondaryColor: widget.secondaryColor,
      onDaysSelected: widget.onDaysSelected,
    );
  }

  void setWeekDays() {
    weekDayNames.clear();
    if (widget.calMode == CalendarMode.PERSIAN) {
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
