import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'all_providers.dart';
import 'core/logic/base_datetime.dart';
import 'core/logic/calendar_mode.dart';
import 'core/styles.dart';
import 'core/ui/widget/drop_down_widget.dart';
import 'dialog/color_picker_dialog.dart';
import 'dialog/date_picker_dialog.dart';
import 'generated/l10n.dart';
import 'provider/main_provider.dart';

class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final List<CalendarMode> calendarModeList = CalendarMode.values;

  final TextEditingController yearFromCtrl = TextEditingController();

  final TextEditingController yearRangeCtrl = TextEditingController();

  void _showRangePicker(BuildContext context, MainProvider provider) {
    showDialog(
        context: context,
        builder: (_) => MyDatePickerDialog(
              initialDate: BaseDateTime.now(),
              showRange: provider.showRange,
              showTime: provider.showTime,
              yearRange: [int.parse(yearFromCtrl.text), int.parse(yearRangeCtrl.text)],
              calMode: provider.calMode,
              onSubmitTap: (_) {
                Navigator.of(context).pop();
              },
            ));
  }

  changeLocale(MainProvider provider, CalendarMode mode) {
    if (mode == CalendarMode.PERSIAN) {
      provider.locale = const Locale.fromSubtags(languageCode: 'fa');
    } else {
      provider.locale = const Locale.fromSubtags(languageCode: 'en');
    }
  }

  @override
  void initState() {
    yearFromCtrl.text = "2010";
    yearRangeCtrl.text = "20";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainProvider provider = ref.watch(AllProvider.mainProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
        backgroundColor: provider.color,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.of(context).calMode),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 150,
                  child: DropDownWidget<CalendarMode>(
                    items: CalendarMode.values,
                    valueStyle: Styles.s14w4b,
                    onChanged: (CalendarMode? newValue) {
                      if (newValue != null) {
                        provider.calMode = newValue;
                        changeLocale(provider, newValue);
                      }
                    },
                    value: provider.calMode,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.of(context).showRange),
                Switch(
                  value: provider.showRange,
                  activeColor: provider.color,
                  onChanged: (bool value) {
                    provider.showRange = value;
                  },
                )
              ],
            ),
            // Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Text(S.of(context).showTime),
            //     Switch(
            //       value: provider.showTime,
            //       activeColor: provider.color,
            //       onChanged: (bool value) {
            //         provider.showTime = value;
            //       },
            //     )
            //   ],
            // ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.of(context).showYear),
                SizedBox(width: 10,),
                Text(S.of(context).from),
                SizedBox(width: 10,),
                Container(
                    width: 100,
                    child: TextFormField(controller: yearFromCtrl,)),
                SizedBox(width: 10,),
                Text("until"),
                SizedBox(width: 10,),
                Container(
                    width: 50,
                    child: TextFormField(controller: yearRangeCtrl,)),
                Text("years later"),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.of(context).pickColor),
                const SizedBox(
                  width: 10,
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => showDialog(
                        context: context,
                        builder: (_) => ColorPickerDialog(
                              color: provider.color,
                              onColorSubmit: (color) {
                                provider.color = color;
                                Navigator.pop(context);
                              },
                            )),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: provider.color,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: provider.color,
        onPressed: () => _showRangePicker(context, provider),
        tooltip: S.of(context).datePicker,
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}
