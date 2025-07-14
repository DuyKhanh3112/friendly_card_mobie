// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:get/get.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Get.width * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${usersController.user.value.fullname}!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00008B), // Dark Blue
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Let's start the day with some vocabulary!",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: Get.width * 0.15,
            height: Get.width * 0.15,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png'),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
    });
  }
}
