import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../styles.dart';

class InRangeCell extends StatelessWidget {
  final String text;
  final double cellWidth;
  final double cellHeight;

  const InRangeCell({
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: const BoxDecoration(
          color: AppColor.lightPinkColor,
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
