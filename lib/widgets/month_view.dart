import 'package:custom_date_picker/extensions.dart';
import 'package:custom_date_picker/widgets/range_head_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../all_providers.dart';
import '../provider/date_provider.dart';
import 'bordered_cell.dart';
import 'calendar_header.dart';
import 'disable_cell.dart';
import 'filled_cell.dart';
import 'in_range_cell.dart';
import 'normal_cell.dart';
import 'other_month_cell.dart';
import 'weekday_widget.dart';

class MonthView extends ConsumerStatefulWidget {
  final List<DateTime>? disableDates;
  final bool isRangeSelection;

  const MonthView({
    required this.isRangeSelection,
    super.key,
    this.disableDates,
  });

  @override
  ConsumerState<MonthView> createState() =>
      _RangeSelectionMonthView();
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
    DateTime firstDay =
        DateTime.utc(provider.currentYear, provider.currentMonth, 1);
    DateTime lastDay =
        DateTime.utc(provider.currentYear, provider.currentMonth + 1, 0);

    indexToSkip = firstDay.weekday - 1;
    rowsNumber = ((lastDay.day + indexToSkip) / 7).ceil();

    return Column(children: [
      CalendarHeader(
        firstDay: firstDay,
        dateFormat: DateFormat.yMMMM(),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        color: Colors.white,
        child: Table(
          // border: TableBorder.all(),
          children: [
            TableRow(children: [
              ...List.generate(
                // Week Days names
                7,
                (index) => WeekdayWidget(
                  cellHeight: cellHeight,
                  cellWidth: cellWidth,
                  weekday: weekDayNames[index],
                ),
              ),
            ]),
            ...List.generate(
              rowsNumber,
              (rowIndex) => TableRow(children: [
                ...List.generate(
                  7,
                  (colIndex) {
                    DateTime currentDay = firstDay.add(Duration(
                        days: ((rowIndex * 7) + colIndex) - indexToSkip));

                    if (widget.disableDates != null &&
                        currentDay.isInList(widget.disableDates!)) {
                      // for disable days
                      return DisableCell(
                        text: currentDay.day.toString(),
                        cellWidth: cellWidth,
                        cellHeight: cellHeight,
                      );
                    } else {
                      return widget.isRangeSelection
                          ? generateRangeCell(
                              currentDay: currentDay,
                              firstDay: firstDay,
                              isNotPreviousMonth:
                                  ((rowIndex * 7) + colIndex) >= indexToSkip,
                            )
                          : generateSingleCell(
                              currentDay: currentDay,
                              firstDay: firstDay,
                              isNotPreviousMonth:
                                  ((rowIndex * 7) + colIndex) >= indexToSkip,
                            );
                    }
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget generateSingleCell(
      {required DateTime currentDay,
      required DateTime firstDay,
      required bool isNotPreviousMonth}) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    Widget cell;
    int whichMonth = 0; //in this month

    if (currentDay.isInMonth(firstDay)) {
      whichMonth = 0;

      cell = provider.currentDay.compareWithoutTime(currentDay)
          ? FilledCell(
              cellWidth: cellWidth,
              cellHeight: cellHeight,
              text: currentDay.day.toString(),
            )
          : currentDay.isToday()
              ? BorderedCell(
                  cellWidth: cellWidth,
                  cellHeight: cellHeight,
                  text: currentDay.day.toString(),
                )
              : NormalCell(
                  cellWidth: cellWidth,
                  cellHeight: cellHeight,
                  text: currentDay.day.toString(),
                );
    } else {
      whichMonth = isNotPreviousMonth ? 1 : -1;
      cell = OtherMonthCell(
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        text: currentDay.day.toString(),
      );
    }

    return GestureDetector(
        onTap: () => onSingleDaysTap(
              currentDay: currentDay,
              whichMonth: whichMonth,
            ),
        child: cell);
  }

  void onSingleDaysTap({
    required DateTime currentDay,
    required int whichMonth,
    DateTime? selectedDay,
  }) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    switchMonth(provider, whichMonth);

    provider.currentDay = currentDay;
  }

  Widget generateRangeCell(
      {required DateTime currentDay,
      required DateTime firstDay,
      required bool isNotPreviousMonth}) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    Widget cell;
    int whichMonth = 0; //in this month

    if (provider.rangeList.contains(currentDay)) {
      cell = _rangeCells(currentDay);
    } else {
      if (currentDay.isInMonth(firstDay)) {
        whichMonth = 0;
        if (currentDay.isToday()) {
          cell = BorderedCell(
            text: currentDay.day.toString(),
            cellWidth: cellWidth,
            cellHeight: cellHeight,
          );
        } else {
          // normal
          cell = NormalCell(
            text: currentDay.day.toString(),
            cellWidth: cellWidth,
            cellHeight: cellHeight,
          );
        }
      } else {
        // other month
        whichMonth = isNotPreviousMonth ? 1 : -1;
        cell = OtherMonthCell(
          text: currentDay.day.toString(),
          cellWidth: cellWidth,
          cellHeight: cellHeight,
        );
      }
    }
    return GestureDetector(
        onTap: () => onRangeDaysTap(
              currentDay: currentDay,
              whichMonth: whichMonth,
            ),
        child: cell);
  }

  Widget _rangeCells(DateTime currentDay) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    Widget cell;

    if (provider.selectedDay1 != null &&
        provider.selectedDay1!.compareWithoutTime(currentDay)) {
      cell = RangeHeadCell(
        text: currentDay.day.toString(),
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        headPosition: HeadPosition.start,
        showTail:
            provider.selectedDay1 != null && provider.selectedDay2 != null,
      );
    } else if (provider.selectedDay2 != null &&
        provider.selectedDay2!.compareWithoutTime(currentDay)) {
      cell = RangeHeadCell(
        text: currentDay.day.toString(),
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        headPosition: HeadPosition.end,
        showTail:
            provider.selectedDay1 != null && provider.selectedDay2 != null,
      );
    } else {
      cell = InRangeCell(
        text: currentDay.day.toString(),
        cellWidth: cellWidth,
        cellHeight: cellHeight,
      );
    }

    return cell;
  }

  void onRangeDaysTap({
    required DateTime currentDay,
    required int whichMonth,
    DateTime? selectedDay,
  }) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    switchMonth(provider, whichMonth);

    if (provider.selectedDay1 != null && provider.selectedDay2 == null) {
      provider.selectedDay2 = currentDay;
    } else {
      provider.selectedDay1 = currentDay;
    }
  }

  switchMonth(DateProvider provider, int whichMonth) {
    switch (whichMonth) {
      case -1:
        provider.lastMonth();
        break;
      case 1:
        provider.nextMonth();
        break;
      default:
        break;
    }
  }
}
