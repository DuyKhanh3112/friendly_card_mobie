// ignore_for_file: file_names, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friendly_card_mobile/utils/app_color.dart';
import 'package:get/get.dart';

enum ContactType { mail, phone, number }

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.required,
    this.onChanged,
    this.isPassword,
    this.controller,
    this.readOnly,
    this.type,
    this.hint,
    this.multiLines,
    this.bgColor,
    this.prefix,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool? required;
  final bool? readOnly;
  final bool? isPassword;
  final bool? multiLines;
  final void Function(String)? onChanged;
  final ContactType? type;
  final Color? bgColor;
  final Icon? prefix;

  @override
  Widget build(BuildContext context) {
    RxBool hideContent = (isPassword ?? false).obs;
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: Get.width * 0.025),
        // width: Get.width * 0.3,
        decoration: const BoxDecoration(),
        child: TextFormField(
          controller: controller,
          style: TextStyle(
            fontSize: 16,
            color: AppColor.blue,
            fontWeight: FontWeight.bold,
            backgroundColor: bgColor,
          ),
          obscureText: hideContent.value,
          maxLines: multiLines == true ? 3 : 1,
          keyboardType:
              type == ContactType.number ? TextInputType.number : null,
          inputFormatters: type == ContactType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          minLines: 1,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontSize: 16,
              color: AppColor.blue,
              fontWeight: FontWeight.bold,
              backgroundColor: bgColor,
            ),
            // hintText: 'Nhập ${label.toLowerCase()}',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.blue, width: 2),
            ),
            prefixIcon: prefix,

            suffixIcon: isPassword == true
                ? IconButton(
                    onPressed: () {
                      hideContent.value = !hideContent.value;
                    },
                    icon: hideContent.value
                        ? Icon(
                            Icons.remove_red_eye_outlined,
                            color: AppColor.blue,
                          )
                        : Icon(
                            Icons.remove_red_eye_rounded,
                            color: AppColor.blue,
                          ),
                  )
                : null,
          ),
          validator: (value) {
            if (required == true) {
              if (value == null || value.trim() == '' || value.isEmpty) {
                return 'Vui lòng nhập $label';
              }
              if (type == ContactType.mail) {
                final RegExp emailRegExp = RegExp(
                  r"^[\w-\.]+@([\w-]+\.){1,}[\w-]{1,}$",
                );
                if (!emailRegExp.hasMatch(value)) {
                  return '${label} không hợp lệ. Ví dụ: user@gmail.com';
                }
              }
              if (type == ContactType.number) {
                if (num.parse(value) <= 0) {
                  return '${label} phải lớn hơn 0.';
                }
              }
            }
            return null;
          },
          onChanged: onChanged ?? (value) {},
          readOnly: readOnly ?? false,
          enabled: !(readOnly ?? false),
        ),
      ),
    );
  }
}
