import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../styles.dart';


class DropDownWidget<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final onChanged;
  final String? hintText;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? valueStyle;

  const DropDownWidget({
    Key? key,
    this.value,
    required this.items,
    this.onChanged,
    this.hintText,
    this.hintStyle,
    this.valueStyle,
    this.labelText,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle ?? Styles.s14w3g5,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.white1, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.white1, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      menuMaxHeight: 300,
      hint: Text(
        hintText ?? "Please Select",
        style: hintStyle ?? Styles.s18w7b,
      ),
      value: value,
      icon: Icon(Icons.arrow_drop_down_outlined, size: 16,),
      isExpanded: true,
      // itemHeight: 48,
      // iconSize: 16,
      items: items.map((T item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item.toString(),
            style: valueStyle ?? Styles.s18w7b,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
