import 'package:flutter/material.dart';

import '../../styles.dart';

class FilledCell extends StatelessWidget {
  final String text;
  final double cellWidth;
  final double cellHeight;
  final Color? color;

  const FilledCell({
    Key? key,
    required this.text,
    required this.cellWidth,
    required this.cellHeight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color ?? Colors.blue,
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
