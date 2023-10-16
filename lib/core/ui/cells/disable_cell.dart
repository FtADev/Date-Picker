import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../styles.dart';


class DisableCell extends StatelessWidget {
  final String text;
  final double cellWidth;
  final double cellHeight;
  const DisableCell({Key? key, required this.text, required this.cellHeight, required this.cellWidth,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColor.gray1,
      child: SizedBox(
        width: cellWidth,
        height: cellHeight,
        child: Center(
          child: Text(
            text,
            style: Styles.s14w4w,
          ),
        ),
      ),
    );
  }
}
