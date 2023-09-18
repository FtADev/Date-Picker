import 'package:custom_date_picker/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../all_providers.dart';
import '../provider/date_provider.dart';
import '../styles.dart';
import 'calendar_header.dart';
import 'cells/bordered_cell.dart';
import 'cells/disable_cell.dart';
import 'cells/filled_cell.dart';
import 'cells/in_range_cell.dart';
import 'cells/normal_cell.dart';
import 'cells/other_month_cell.dart';
import 'cells/range_head_cell.dart';
import 'weekday_widget.dart';

class UIPart extends ConsumerStatefulWidget {
  const UIPart({
      required this.isRangeSelection,
      required this.rowsNumber,
      required this.monthName,
      required this.weekdays,
      required this.disableDates,
      required this.firstDay,
      required this.indexToSkip,
      Key? key})
      : super(key: key);
  final int rowsNumber;
  final String monthName;
  final List<String> weekdays;
  final List<DateTime>? disableDates;
  final DateTime firstDay;
  final int indexToSkip;
  final bool isRangeSelection;


  @override
  ConsumerState<UIPart> createState() => _UIPartState();
}

class _UIPartState extends ConsumerState<UIPart> {
  double cellWidth = 32;
  double cellHeight = 40;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CalendarHeader(
        monthName: widget.monthName,
        monthStyle: Styles.s16w7b,
        leftArrow: const Icon(
          Icons.chevron_left,
          size: 16,
        ),
        rightArrow: const Icon(
          Icons.chevron_right,
          size: 16,
        ),
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
                  weekday: widget.weekdays[index],
                ),
              ),
            ]),
            ...List.generate(
              widget.rowsNumber,
              (rowIndex) => TableRow(children: [
                ...List.generate(
                  7,
                  (colIndex) {
                    DateTime currentDay = widget.firstDay.add(Duration(
                        days: ((rowIndex * 7) + colIndex) - widget.indexToSkip));

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
                              firstDay: widget.firstDay,
                              isNotPreviousMonth:
                                  ((rowIndex * 7) + colIndex) >= widget.indexToSkip,
                            )
                          : generateSingleCell(
                              currentDay: currentDay,
                              firstDay: widget.firstDay,
                              isNotPreviousMonth:
                                  ((rowIndex * 7) + colIndex) >= widget.indexToSkip,
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
