// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    super.key,
    required this.title,
    this.textStyle,
    this.align,
  });

  final String title;
  final TextStyle? textStyle;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.02),
      alignment: align == TextAlign.center
          ? Alignment.center
          : align == TextAlign.left
              ? Alignment.centerLeft
              : align == TextAlign.right
                  ? Alignment.centerRight
                  : null,
      child: Text(
        title.toUpperCase(),
        textAlign: align,
        style: textStyle,
      ),
    );
  }
}
