import 'package:custom_date_picker/core/other_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../all_providers.dart';
import '../../widgets/drop_down_widget.dart';
import '../app_colors.dart';
import '../core/calendar_mode.dart';
import '../functions.dart';
import '../provider/date_provider.dart';
import '../styles.dart';
import '../widgets/month_view.dart';
import '../widgets/rounded_button.dart';

class MyDatePickerDialog extends ConsumerStatefulWidget {
  final DateTime initialDate;
  final List<DateTime>? disableDates;
  final onSubmitTap;
  final bool showTime;
  final bool showYear;
  final bool showRange;
  final CalendarMode calMode;

  const MyDatePickerDialog({
    this.disableDates,
    required this.initialDate,
    Key? key,
    required this.onSubmitTap,
    this.showTime = true,
    this.showYear = false,
    this.showRange = false,
    this.calMode = CalendarMode.GREGORIAN, //default mode
  }) : super(key: key);

  @override
  ConsumerState<MyDatePickerDialog> createState() => _MyDatePickerDialogState();
}

class _MyDatePickerDialogState extends ConsumerState<MyDatePickerDialog> {
  late TimeOfDay selectedTime;
  late TimeOfDay selectedTime1;
  late TimeOfDay selectedTime2;
  List<int> yearList = [];

  @override
  void initState() {
    setYearsList();

    selectedTime = TimeOfDay(
        hour: widget.initialDate.hour, minute: widget.initialDate.minute);
    selectedTime1 = TimeOfDay(
        hour: widget.initialDate.hour, minute: widget.initialDate.minute);
    selectedTime2 = TimeOfDay(
        hour: widget.initialDate.hour, minute: widget.initialDate.minute);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DateProvider provider = ref.watch(AllProvider.dateProvider);
      provider.calMode = widget.calMode;
      provider.currentDay =
          OtherFunctions.convertToBaseDate(widget.calMode, widget.initialDate);
      provider.showDay =
          OtherFunctions.convertToBaseDate(widget.calMode, widget.initialDate);
      provider.currentYear = yearList.first;
    });
    super.initState();
  }

  void setYearsList() {
    yearList.clear();
    int currentYear = DateTime.now().year;

    //TODO(Should be unlimited)
    for (int i = currentYear; i >= currentYear - 20; i--) {
      yearList.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      children: [
        Directionality(
          textDirection: OtherFunctions.getTextDirection(widget.calMode),
          child: Container(
            width: 300,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("Date:", style: Styles.s18w7b),
                      const Spacer(),
                      widget.showYear
                          ? SizedBox(
                              width: 100,
                              child: DropDownWidget<int>(
                                items: yearList,
                                hintText: provider.currentYear.toString(),
                                hintStyle: Styles.s16w7p,
                                valueStyle: Styles.s16w7p,
                                onChanged: (int? year) {
                                  if (year != null) {
                                    provider.currentYear = year;
                                  }
                                },
                                value: provider.currentYear,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  widget.showRange ? rangeDate() : normalDate(),
                  const SizedBox(
                    height: 10,
                  ),
                  MonthView(
                    calMode: widget.calMode,
                    disableDates: widget.disableDates,
                    isRangeSelection: widget.showRange,
                  ),
                  widget.showTime
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              const Divider(
                                color: AppColor.gray0,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Time:", style: Styles.s18w7b),
                              const SizedBox(
                                height: 5,
                              ),
                              widget.showRange ? rangeTime() : normalTime(),
                            ])
                      : Container(),
                  const SizedBox(
                    height: 30,
                  ),
                  RoundedButton(
                    title: "Submit",
                    onTap: () {
                      if (widget.showRange) {
                        if (provider.selectedDay1 == null) {
                          debugPrint("Please select start date");
                          return;
                        }
                        if (provider.selectedDay2 == null) {
                          debugPrint("Please select end date");
                          return;
                        }
                      }
                      if (widget.showRange) {
                        debugPrint("First day: ${provider.selectedDay1}");
                        debugPrint("Second day: ${provider.selectedDay2}");
                      } else {
                        debugPrint("Selected day: ${provider.currentDay}");
                      }
                      Navigator.of(context).pop();
                    },
                    height: 55,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget rangeDate() {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        provider.selectedDay1 != null
            ? Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    const Text("From: ", style: Styles.s16w7b),
                    Text(provider.selectedDay1?.toString() ?? "",
                        style: Styles.s16w7p),
                  ],
                ),
              )
            : Container(),
        provider.selectedDay2 != null
            ? Row(
                children: [
                  const Text("To: ", style: Styles.s16w7b),
                  Text(provider.selectedDay2?.toString() ?? "",
                      style: Styles.s16w7p),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget normalDate() {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    return Text(provider.currentDay.toString(), style: Styles.s16w7p);
  }

  Widget rangeTime() {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              TimeOfDay? pickedTime = await Functions.onTimeTap(
                context,
                selected: selectedTime1,
              );
              if (pickedTime != null) {
                setState(() {
                  selectedTime1 = pickedTime;
                });
              } else {
                debugPrint("Time is not selected");
              }
            },
            child: Text(
                DateFormat.jm().format(
                  Functions.combineDateAndTime(
                    provider.selectedDay1 ?? DateTime.now(),
                    selectedTime1,
                  ),
                ),
                style: Styles.s16w7p),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text("to", style: Styles.s16w7b),
        const SizedBox(
          width: 10,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              TimeOfDay? pickedTime = await Functions.onTimeTap(
                context,
                selected: selectedTime2,
              );
              if (pickedTime != null) {
                setState(() {
                  selectedTime2 = pickedTime;
                });
              } else {
                debugPrint("Time is not selected");
              }
            },
            child: Text(
                DateFormat.jm().format(
                  Functions.combineDateAndTime(
                    provider.selectedDay2 ?? DateTime.now(),
                    selectedTime2,
                  ),
                ),
                style: Styles.s16w7p),
          ),
        ),
      ],
    );
  }

  Widget normalTime() {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          TimeOfDay? pickedTime = await Functions.onTimeTap(
            context,
            selected: selectedTime,
          );
          if (pickedTime != null) {
            setState(() {
              selectedTime = pickedTime;
            });
          } else {
            debugPrint("Time is not selected");
          }
        },
        child: Text(
            DateFormat.jm().format(
              Functions.combineDateAndTime(
                provider.currentDay,
                selectedTime,
              ),
            ),
            style: Styles.s16w7p),
      ),
    );
  }
}
