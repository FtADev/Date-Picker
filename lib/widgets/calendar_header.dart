import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../all_providers.dart';
import '../provider/date_provider.dart';
import '../styles.dart';

class CalendarHeader extends ConsumerWidget {
  const CalendarHeader(
      {this.monthStyle,
      this.dateFormat,
      this.leftArrow,
      this.rightArrow,
      Key? key,
      required this.firstDay})
      : super(key: key);

  final DateTime firstDay;
  final Widget? leftArrow;
  final Widget? rightArrow;
  final TextStyle? monthStyle;
  final DateFormat? dateFormat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateProvider provider = ref.watch(AllProvider.dateProvider);

    return Row(children: [
      Text(
        dateFormat?.format(firstDay) ?? DateFormat.yMMMM().format(firstDay),
        style: monthStyle ?? Styles.s16w7b,
      ),
      const Spacer(),
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => provider.lastMonth(),
          child: leftArrow ??
              const Icon(
                Icons.chevron_left,
                size: 16,
              ),
        ),
      ),
      const SizedBox(
        width: 20,
      ),
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => provider.nextMonth(),
          child: rightArrow ??
              const Icon(
                Icons.chevron_right,
                size: 16,
              ),
        ),
      ),
    ]);
  }
}
