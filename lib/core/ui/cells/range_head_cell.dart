import 'package:flutter/material.dart';

import '../../styles.dart';

enum HeadPosition { start, end }

class RangeHeadCell extends StatelessWidget {
  final String text;
  final double cellWidth;
  final double cellHeight;
  final HeadPosition headPosition;
  final bool showTail;
  final Color? primaryColor;
  final Color? secondaryColor;

  const RangeHeadCell({
    Key? key,
    required this.text,
    required this.cellWidth,
    required this.cellHeight,
    required this.headPosition,
    required this.showTail,
    this.primaryColor,
    this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          showTail
              ? Align(
                  alignment: headPosition == HeadPosition.start
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart,
                  child: Container(
                    height: cellHeight - 12,
                    width: cellWidth / 2,
                    color: secondaryColor ?? Colors.blue[200],
                  ),
                )
              : Container(),
          CircleAvatar(
            backgroundColor: primaryColor ?? Colors.blue,
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
