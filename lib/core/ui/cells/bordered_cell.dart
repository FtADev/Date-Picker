import 'package:flutter/material.dart';

import '../../styles.dart';


class BorderedCell extends StatelessWidget {
  final String text;
  final double cellWidth;
  final double cellHeight;
  final Color? color;

  const BorderedCell({
    Key? key,
    required this.text,
    required this.cellWidth,
    required this.cellHeight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellWidth,
      height: cellHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: color ?? Colors.blue,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: Styles.s14w4b,
        ),
      ),
    );
  }
}
