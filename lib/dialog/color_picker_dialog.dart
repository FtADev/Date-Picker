import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../core/app_colors.dart';
import '../generated/l10n.dart';
import '../core/styles.dart';
import '../core/ui/widget/rounded_button.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color color;
  final onColorSubmit;

  const ColorPickerDialog({Key? key, required this.color, this.onColorSubmit})
      : super(key: key);

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color color;

  @override
  void initState() {
    color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      scrollable: true,
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      content: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).pickColor,
                  style: Styles.s16w7b,
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    // onTap: () => getIt<NavigationService>().goBack(),
                    child: const Icon(
                      Icons.close,
                      color: AppColor.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ColorPicker(
            pickerColor: color,
            onColorChanged: onColorChanged,
            colorPickerWidth: 300,
            pickerAreaHeightPercent: 0.7,
            enableAlpha: false,
            displayThumbColor: true,
            paletteType: PaletteType.hsv,
            labelTypes: const [],
            pickerAreaBorderRadius: const BorderRadius.only(
              topLeft: Radius.circular(2),
              topRight: Radius.circular(2),
            ),
            // hexInputController: textController,
            portraitOnly: true,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundedButton(
              title: S.of(context).submit,
              color: color,
              onTap: () => widget.onColorSubmit(color),
              height: 55,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  onColorChanged(Color newColor) {
    setState(() {
      color = newColor;
    });
  }
}
