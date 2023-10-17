import 'package:custom_date_picker/core/logic/other_functions.dart';
import 'package:custom_date_picker/provider/dialog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../all_providers.dart';
import '../core/app_colors.dart';
import '../core/logic/calendar_mode.dart';
import '../core/provider/date_provider.dart';
import '../core/styles.dart';
import '../core/ui/month_view.dart';
import '../core/ui/widget/rounded_button.dart';
import '../functions.dart';
import '../generated/l10n.dart';
import '../provider/main_provider.dart';

class MyDatePickerDialog extends ConsumerStatefulWidget {
  final DateTime initialDate;
  final List<DateTime>? disableDates;
  final onSubmitTap;
  final bool showTime;
  // final bool showYear;
  final bool showRange;
  final CalendarMode calMode;

  const MyDatePickerDialog({
    this.disableDates,
    required this.initialDate,
    Key? key,
    required this.onSubmitTap,
    this.showTime = true,
    // this.showYear = false,
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

  @override
  void initState() {
    selectedTime = TimeOfDay(
        hour: widget.initialDate.hour, minute: widget.initialDate.minute);
    selectedTime1 = TimeOfDay(
        hour: widget.initialDate.hour, minute: widget.initialDate.minute);
    selectedTime2 = TimeOfDay(
        hour: widget.initialDate.hour, minute: widget.initialDate.minute);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DialogProvider provider = ref.watch(AllProvider.dialogProvider);

      provider.calMode = widget.calMode;
      provider.currentDay =
          OtherFunctions.convertToBaseDate(widget.calMode, widget.initialDate);
      provider.showDay =
          OtherFunctions.convertToBaseDate(widget.calMode, widget.initialDate);
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    DialogProvider provider = ref.watch(AllProvider.dialogProvider);
    MainProvider mainProvider = ref.watch(AllProvider.mainProvider);

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
                      Text(S.of(context).date, style: Styles.s18w7b),
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
                    primaryColor: mainProvider.color,
                    secondaryColor: mainProvider.color.withOpacity(0.2),
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
                              Text(S.of(context).time, style: Styles.s18w7b),
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
                    title: S.of(context).submit,
                    color: mainProvider.color,
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
    DialogProvider provider = ref.watch(AllProvider.dialogProvider);
    MainProvider mainProvider = ref.watch(AllProvider.mainProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        provider.selectedDay1 != null
            ? Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Text(S.of(context).from, style: Styles.s16w7b),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(provider.selectedDay1?.toString() ?? "",
                        style:
                            Styles.s16w7p.copyWith(color: mainProvider.color)),
                  ],
                ),
              )
            : Container(),
        provider.selectedDay2 != null
            ? Row(
                children: [
                  Text(S.of(context).to, style: Styles.s16w7b),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(provider.selectedDay2?.toString() ?? "",
                      style: Styles.s16w7p.copyWith(color: mainProvider.color)),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget normalDate() {
    DialogProvider provider = ref.watch(AllProvider.dialogProvider);
    MainProvider mainProvider = ref.watch(AllProvider.mainProvider);

    return Text(provider.currentDay.toString(),
        style: Styles.s16w7p.copyWith(color: mainProvider.color));
  }

  Widget rangeTime() {
    DialogProvider provider = ref.watch(AllProvider.dialogProvider);
    MainProvider mainProvider = ref.watch(AllProvider.mainProvider);

    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              TimeOfDay? pickedTime = await Functions.onTimeTap(context,
                  selected: selectedTime1, color: mainProvider.color);
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
                style: Styles.s16w7p.copyWith(color: mainProvider.color)),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(S.of(context).to, style: Styles.s16w7b),
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
                color: mainProvider.color,
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
                style: Styles.s16w7p.copyWith(color: mainProvider.color)),
          ),
        ),
      ],
    );
  }

  Widget normalTime() {
    DateProvider provider = ref.watch(AllProvider.dateProvider);
    MainProvider mainProvider = ref.watch(AllProvider.mainProvider);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          TimeOfDay? pickedTime = await Functions.onTimeTap(
            context,
            selected: selectedTime,
            color: mainProvider.color,
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
            style: Styles.s16w7p.copyWith(color: mainProvider.color)),
      ),
    );
  }
}
