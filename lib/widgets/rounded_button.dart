import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../styles.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final onTap;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color color;

  const RoundedButton(
      {Key? key,
      required this.title,
      this.onTap,
      this.isLoading = false,
      this.width,
      this.height,
      this.color = AppColor.pinkColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height ?? 55,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: isLoading
                ? Container(
                    margin: const EdgeInsets.all(10),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text(
                  title,
                  style: Styles.s18w7w,
                ),
          ),
        ),
      ),
    );
  }
}
