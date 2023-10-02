import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'all_providers.dart';
import 'core/base_datetime.dart';
import 'core/calendar_mode.dart';
import 'dialog/date_picker_dialog.dart';
import 'generated/l10n.dart';
import 'provider/main_provider.dart';
import 'styles.dart';
import 'widgets/drop_down_widget.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  final List<CalendarMode> calendarModeList = CalendarMode.values;

  void _showRangePicker(BuildContext context, MainProvider provider) {
    showDialog(
        context: context,
        builder: (_) => MyDatePickerDialog(
              initialDate: BaseDateTime.now(),
              showRange: provider.showRange,
              showTime: provider.showTime,
              showYear: provider.showYear,
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
  Widget build(BuildContext context, WidgetRef ref) {
    MainProvider provider = ref.watch(AllProvider.mainProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
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
                  onChanged: (bool value) {
                    provider.showRange = value;
                  },
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.of(context).showTime),
                Switch(
                  value: provider.showTime,
                  onChanged: (bool value) {
                    provider.showTime = value;
                  },
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.of(context).showYear),
                Switch(
                  value: provider.showYear,
                  onChanged: (bool value) {
                    provider.showYear = value;
                  },
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRangePicker(context, provider),
        tooltip: S.of(context).datePicker,
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}
