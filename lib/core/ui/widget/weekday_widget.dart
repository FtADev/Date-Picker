import 'package:flutter/material.dart';

import '../../styles.dart';

class WeekdayWidget extends StatelessWidget {
  const WeekdayWidget(
      {Key? key,
      required this.weekday,
      this.weekdayStyle,
      required this.cellWidth,
      required this.cellHeight})
      : super(key: key);

  final String weekday;
  final TextStyle? weekdayStyle;
  final double cellWidth;
  final double cellHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // padding: const EdgeInsets.all(10),
      width: cellWidth,
      height: cellHeight,
      child: Center(
          child: Text(
        weekday,
        style: weekdayStyle ?? Styles.s14w7g1,
      )),
    );
  }
}
