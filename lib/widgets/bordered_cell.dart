import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../styles.dart';


class BorderedCell extends StatelessWidget {
  final String text;
  final double cellWidth;
  final double cellHeight;

  const BorderedCell({
    Key? key,
    required this.text,
    required this.cellWidth,
    required this.cellHeight,
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
          color: AppColor.pinkColor,
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
