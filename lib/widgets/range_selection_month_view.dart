import 'package:custom_date_picker/extensions.dart';
import 'package:custom_date_picker/widgets/range_head_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../all_providers.dart';
import '../provider/date_provider.dart';
import '../styles.dart';
import 'bordered_cell.dart';
import 'calendar_header.dart';
import 'disable_cell.dart';
import 'in_range_cell.dart';
import 'normal_cell.dart';
import 'other_month_cell.dart';
import 'weekday_widget.dart';

class RangeSelectionMonthView extends ConsumerStatefulWidget {
  final List<DateTime>? disableDates;

  const RangeSelectionMonthView({
    super.key,
    this.disableDates,
  });

  @override
  ConsumerState<RangeSelectionMonthView> createState() =>
      _RangeSelectionMonthView();
}

class _RangeSelectionMonthView extends ConsumerState<RangeSelectionMonthView> {
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
                      return generateCell(
                        currentDay: currentDay,
                        firstDay: firstDay,
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

  Widget generateCell({
    required DateTime currentDay,
    required DateTime firstDay,
  }) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    Widget cell;

    if (provider.rangeList.contains(currentDay)) {
      cell = rangeCells(currentDay);
    } else {
      if (currentDay.isInMonth(firstDay)) {
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
        cell = OtherMonthCell(
          text: currentDay.day.toString(),
          cellWidth: cellWidth,
          cellHeight: cellHeight,
        );
      }
    }
    return GestureDetector(
        onTap: () => onDaysTap(currentDay: currentDay), child: cell);
  }

  Widget rangeCells(DateTime currentDay) {
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

  onDaysTap({required DateTime currentDay, DateTime? selectedDay}) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    if (provider.selectedDay1 != null && provider.selectedDay2 == null) {
      provider.selectedDay2 = currentDay;
    } else {
      provider.selectedDay1 = currentDay;
    }
  }
}
