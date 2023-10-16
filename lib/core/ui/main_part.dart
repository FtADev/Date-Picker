import 'package:custom_date_picker/core/logic/base_datetime.dart';
import 'package:custom_date_picker/core/logic/extensions.dart';
import 'package:custom_date_picker/core/logic/other_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../all_providers.dart';
import '../logic/calendar_mode.dart';
import '../provider/date_provider.dart';
import '../styles.dart';
import 'widget/calendar_header.dart';
import 'cells/bordered_cell.dart';
import 'cells/disable_cell.dart';
import 'cells/filled_cell.dart';
import 'cells/in_range_cell.dart';
import 'cells/normal_cell.dart';
import 'cells/other_month_cell.dart';
import 'cells/range_head_cell.dart';
import 'widget/weekday_widget.dart';

class MainPart extends ConsumerStatefulWidget {
  const MainPart(
      {this.primaryColor,
      this.secondaryColor,
      required this.isRangeSelection,
      required this.rowsNumber,
      required this.monthName,
      required this.weekdays,
      required this.disableDates,
      required this.firstDay,
      required this.indexToSkip,
      required this.calMode,
      Key? key})
      : super(key: key);
  final int rowsNumber;
  final String monthName;
  final List<String> weekdays;
  final List<DateTime>? disableDates;
  final BaseDateTime firstDay;
  final int indexToSkip;
  final bool isRangeSelection;
  final CalendarMode calMode;
  final Color? primaryColor;
  final Color? secondaryColor;

  @override
  ConsumerState<MainPart> createState() => _UIPartState();
}

class _UIPartState extends ConsumerState<MainPart> {
  double cellWidth = 32;
  double cellHeight = 40;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: OtherFunctions.getTextDirection(widget.calMode),
      child: Column(children: [
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
                      BaseDateTime currentDay = widget.firstDay.addDuration(
                          ((rowIndex * 7) + colIndex) - widget.indexToSkip);
                      if (widget.disableDates != null &&
                          currentDay.isInList(widget.disableDates!)) {
                        // for disable days
                        return DisableCell(
                          text: currentDay.getDay(),
                          cellWidth: cellWidth,
                          cellHeight: cellHeight,
                        );
                      } else {
                        return widget.isRangeSelection
                            ? generateRangeCell(
                                currentDay: currentDay,
                                firstDay: widget.firstDay,
                                isNotPreviousMonth:
                                    ((rowIndex * 7) + colIndex) >=
                                        widget.indexToSkip,
                              )
                            : generateSingleCell(
                                currentDay: currentDay,
                                firstDay: widget.firstDay,
                                isNotPreviousMonth:
                                    ((rowIndex * 7) + colIndex) >=
                                        widget.indexToSkip,
                              );
                      }
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget generateSingleCell(
      {required BaseDateTime currentDay,
      required BaseDateTime firstDay,
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
              text: currentDay.getDay(),
              color: widget.primaryColor,
            )
          : currentDay.isToday()
              ? BorderedCell(
                  cellWidth: cellWidth,
                  cellHeight: cellHeight,
                  text: currentDay.getDay(),
                  color: widget.primaryColor,
                )
              : NormalCell(
                  cellWidth: cellWidth,
                  cellHeight: cellHeight,
                  text: currentDay.getDay(),
                );
    } else {
      whichMonth = isNotPreviousMonth ? 1 : -1;
      cell = OtherMonthCell(
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        text: currentDay.getDay(),
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
    required BaseDateTime currentDay,
    required int whichMonth,
    BaseDateTime? selectedDay,
  }) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    switchMonth(provider, whichMonth);

    provider.currentDay = currentDay;
  }

  Widget generateRangeCell(
      {required BaseDateTime currentDay,
      required BaseDateTime firstDay,
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
            text: currentDay.getDay(),
            cellWidth: cellWidth,
            cellHeight: cellHeight,
            color: widget.primaryColor,
          );
        } else {
          // normal
          cell = NormalCell(
            text: currentDay.getDay(),
            cellWidth: cellWidth,
            cellHeight: cellHeight,
          );
        }
      } else {
        // other month
        whichMonth = isNotPreviousMonth ? 1 : -1;
        cell = OtherMonthCell(
          text: currentDay.getDay(),
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

  Widget _rangeCells(BaseDateTime currentDay) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    Widget cell;

    if (provider.selectedDay1 != null &&
        provider.selectedDay1!.compareWithoutTime(currentDay)) {
      cell = RangeHeadCell(
        text: currentDay.getDay(),
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        primaryColor: widget.primaryColor,
        secondaryColor: widget.secondaryColor,
        headPosition: HeadPosition.start,
        showTail:
            provider.selectedDay1 != null && provider.selectedDay2 != null,
      );
    } else if (provider.selectedDay2 != null &&
        provider.selectedDay2!.compareWithoutTime(currentDay)) {
      cell = RangeHeadCell(
        text: currentDay.getDay(),
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        primaryColor: widget.primaryColor,
        secondaryColor: widget.secondaryColor,
        headPosition: HeadPosition.end,
        showTail:
            provider.selectedDay1 != null && provider.selectedDay2 != null,
      );
    } else {
      cell = InRangeCell(
        text: currentDay.getDay(),
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        color: widget.secondaryColor,
      );
    }

    return cell;
  }

  void onRangeDaysTap({
    required BaseDateTime currentDay,
    required int whichMonth,
    BaseDateTime? selectedDay,
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
