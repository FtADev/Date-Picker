import 'package:flutter/material.dart';

import '../../styles.dart';

class InRangeCell extends StatelessWidget {
  final String text;
  final double cellWidth;
  final double cellHeight;
  final Color? color;

  const InRangeCell({
    Key? key,
    required this.text,
    required this.cellWidth,
    required this.cellHeight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color ?? Colors.blue[200],
        ),
        child: Center(
          child: Text(
            text,
            style: Styles.s14w4b,
          ),
        ),
      ),
    );
  }
}
