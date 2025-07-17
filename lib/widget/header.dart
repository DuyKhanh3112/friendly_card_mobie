// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:friendly_card_mobie/utils/app_color.dart';
import 'package:get/get.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();
    return Obx(() {
      return Container(
        padding: EdgeInsets.only(
          bottom: Get.height * 0.02,
        ),
        decoration: BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${usersController.user.value.fullname}!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.drakBlue,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Let's start the day with some vocabulary!",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ],
            ),
            const CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(
                  'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png'), // Ảnh đại diện mẫu
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
      );
    });
  }
}
