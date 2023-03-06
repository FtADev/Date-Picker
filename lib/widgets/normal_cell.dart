import 'package:flutter/material.dart';

import '../styles.dart';

class NormalCell extends StatelessWidget {
  final String text;
  final double cellWidth;
  final double cellHeight;

  const NormalCell({
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
      decoration: const BoxDecoration(
        color: Colors.white,
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
