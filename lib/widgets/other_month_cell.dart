import 'package:flutter/material.dart';

import '../styles.dart';

class OtherMonthCell extends StatelessWidget {
  final String text;
  final double cellWidth;
  final double cellHeight;

  const OtherMonthCell({
    Key? key,
    required this.text,
    required this.cellWidth,
    required this.cellHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: cellWidth,
        height: cellHeight,
        child: Center(
          child: Text(
            text,
            style: Styles.s14w4g1,
          ),
        ));
  }
}
