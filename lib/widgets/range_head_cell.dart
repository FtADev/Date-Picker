import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../styles.dart';

enum HeadPosition { start, end }

class RangeHeadCell extends StatelessWidget {
  final String text;
  final double cellWidth;
  final double cellHeight;
  final HeadPosition headPosition;
  final bool showTail;

  const RangeHeadCell({
    Key? key,
    required this.text,
    required this.cellWidth,
    required this.cellHeight,
    required this.headPosition,
    required this.showTail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          showTail ? Align(
            alignment: headPosition == HeadPosition.start
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: Container(
              height: cellHeight - 12,
              width: cellWidth / 2,
              color: AppColor.lightPinkColor,
            ),
          ) : Container(),
          CircleAvatar(
            backgroundColor: AppColor.pinkColor,
            child: Center(
              child: Text(
                text,
                style: Styles.s14w4w,
              ),
            ),
          )
        ],
      ),
    );
  }
}
