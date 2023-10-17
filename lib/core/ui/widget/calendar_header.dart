import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../all_providers.dart';
import '../../provider/date_provider.dart';
import '../../styles.dart';
import 'drop_down_widget.dart';

class CalendarHeader extends ConsumerStatefulWidget {
  CalendarHeader({
    this.color,
    required this.monthName,
    required this.monthStyle,
    required this.leftArrow,
    required this.rightArrow,
    Key? key,
  }) : super(key: key);

  final String monthName;
  final TextStyle monthStyle;
  final Widget leftArrow;
  final Widget rightArrow;
  final Color? color;

  @override
  ConsumerState<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends ConsumerState<CalendarHeader> {
  List<int> yearList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DateProvider provider = ref.watch(AllProvider.dateProvider);

      setYearsList();
      provider.currentYear = yearList.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    return Row(children: [
      Text(widget.monthName, style: widget.monthStyle),
      const SizedBox(
        width: 10,
      ),
      SizedBox(
        width: 100,
        child: DropDownWidget<int>(
          items: yearList,
          hintText: provider.currentYear.toString(),
          hintStyle: Styles.s16w7p,
          valueStyle:
              Styles.s16w7p.copyWith(color: widget.color ?? Colors.blue),
          onChanged: (int? year) {
            if (year != null) {
              provider.currentYear = year;
            }
          },
          value: provider.currentYear,
        ),
      ),
      const Spacer(),
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: () => provider.lastMonth(), child: widget.leftArrow),
      ),
      const SizedBox(
        width: 20,
      ),
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: () => provider.nextMonth(), child: widget.rightArrow),
      ),
    ]);
  }

  void setYearsList() {
    yearList.clear();
    int currentYear = DateTime.now().year;

    //TODO(Should be unlimited)
    for (int i = currentYear; i >= currentYear - 20; i--) {
      yearList.add(i);
    }
  }
}
