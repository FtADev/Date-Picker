import 'package:custom_date_picker/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../all_providers.dart';
import '../provider/date_provider.dart';
import 'bordered_cell.dart';
import 'calendar_header.dart';
import 'disable_cell.dart';
import 'filled_cell.dart';
import 'normal_cell.dart';
import 'other_month_cell.dart';
import 'weekday_widget.dart';

class SingleSelectionMonthView extends ConsumerStatefulWidget {
  final List<DateTime>? disableDates;

  SingleSelectionMonthView({this.disableDates});

  @override
  ConsumerState<SingleSelectionMonthView> createState() =>
      _SingleSelectionMonthView();
}

class _SingleSelectionMonthView
    extends ConsumerState<SingleSelectionMonthView> {
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

    DateTime selectedDay = provider.currentDay;

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
              )
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
                        selectedDay: selectedDay,
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

  Widget generateCell(
      {required DateTime currentDay,
      required DateTime firstDay,
      required DateTime selectedDay,
      required bool isNotPreviousMonth}) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    if (isNotPreviousMonth) {
      if (currentDay.isInMonth(firstDay)) {
        if (currentDay.isToday()) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                if (!provider.currentDay.isToday()) {
                  provider.currentDay = currentDay;
                  setState(() {
                    selectedDay = currentDay;
                  });
                }
              },
              child: selectedDay.isToday()
                  // today if selected
                  ? FilledCell(
                      cellWidth: cellWidth,
                      cellHeight: cellHeight,
                      text: currentDay.day.toString(),
                    )
                  : BorderedCell(
                      cellWidth: cellWidth,
                      cellHeight: cellHeight,
                      text: currentDay.day.toString(),
                    ),
            ),
          );
        } else {
          // for other days of this month
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                provider.currentDay = currentDay;
                setState(() {
                  selectedDay = currentDay;
                });
              },
              child: selectedDay.compareWithoutTime(currentDay)
                  ? FilledCell(
                      cellWidth: cellWidth,
                      cellHeight: cellHeight,
                      text: currentDay.day.toString(),
                    )
                  : NormalCell(
                      cellWidth: cellWidth,
                      cellHeight: cellHeight,
                      text: currentDay.day.toString(),
                    ),
            ),
          );
        }
      } else {
        // next month
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              provider.nextMonth();
              provider.currentDay = currentDay;
              setState(() {
                selectedDay = currentDay;
              });
            },
            child: OtherMonthCell(
              cellWidth: cellWidth,
              cellHeight: cellHeight,
              text: currentDay.day.toString(),
            ),
          ),
        );
      }
    } else {
      // previous month
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
            provider.lastMonth();
            provider.currentDay = currentDay;
            setState(() {
              selectedDay = currentDay;
            });
          },
          child: OtherMonthCell(
            cellWidth: cellWidth,
            cellHeight: cellHeight,
            text: currentDay.day.toString(),
          ),
        ),
      );
    }
  }
}
