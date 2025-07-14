// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:friendly_card_mobie/utils/app_color.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.onClicked,
    this.bgColor,
    this.textColor,
  });

  final String title;
  final Future<void> Function()? onClicked;
  final Color? bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      decoration: const BoxDecoration(),
      child: ElevatedButton(
        onPressed: onClicked ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? AppColor.blue,
          foregroundColor: textColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5, // Đổ bóng cho nút
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
