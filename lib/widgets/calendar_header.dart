import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../all_providers.dart';
import '../provider/date_provider.dart';

class CalendarHeader extends ConsumerWidget {
  const CalendarHeader({
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    return Row(children: [
      Text(monthName, style: monthStyle),
      const Spacer(),
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: () => provider.lastMonth(), child: leftArrow),
      ),
      const SizedBox(
        width: 20,
      ),
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: () => provider.nextMonth(), child: rightArrow),
      ),
    ]);
  }
}
