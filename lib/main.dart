import 'package:custom_date_picker/core/base_datetime.dart';
import 'package:custom_date_picker/core/calendar_mode.dart';
import 'package:custom_date_picker/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'all_providers.dart';
import 'dialog/date_picker_dialog.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Date Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Custom Date Picker'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  List<CalendarMode> calendarModeList = CalendarMode.values;

  void _showRangePicker(MainProvider provider) {
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

  @override
  Widget build(BuildContext context) {
    MainProvider provider = ref.watch(AllProvider.mainProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Calendar mode:"),
                const SizedBox(
                  width: 10,
                ),
                DropdownButton<CalendarMode>(
                    value: provider.calMode,
                    onChanged: (CalendarMode? newValue) {
                      if (newValue != null) {
                        provider.calMode = newValue;
                      }
                    },
                    items: CalendarMode.values.map((CalendarMode classType) {
                      return DropdownMenuItem<CalendarMode>(
                          value: classType, child: Text(classType.name));
                    }).toList())
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Show Range"),
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
                const Text("Show Time"),
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
                const Text("Show Year"),
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
        onPressed: () => _showRangePicker(provider),
        tooltip: 'Date Picker',
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.red,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}
