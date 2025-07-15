// ignore_for_file: deprecated_member_use, sized_box_for_whitespace, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:friendly_card_mobie/controllers/main_controller.dart';
import 'package:friendly_card_mobie/controllers/study_history_controller.dart';
import 'package:friendly_card_mobie/controllers/topic_controller.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:friendly_card_mobie/controllers/vocabulary_controller.dart';
import 'package:friendly_card_mobie/models/topic.dart';
import 'package:friendly_card_mobie/widget/loading_page.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    return Obx(() {
      return Scaffold(
        body: mainController.pages[mainController.currentPage.value],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_rounded),
              label: 'Chủ đề',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.gamepad_rounded),
              label: 'Luyện tập',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Cá nhân',
            ),
          ],
          currentIndex: mainController.currentPage.value,
          selectedItemColor: const Color(0xFF4169E1), // Royal Blue
          unselectedItemColor: Colors.grey,
          onTap: (value) async {
            mainController.currentPage.value = value;
            if (value == 0) {
              await mainController.loadData();
            }
          },
          type: BottomNavigationBarType.fixed, // Giữ vị trí cố định
          backgroundColor: Colors.white,
          elevation: 8.0,
        ),
      );
    });
  }
}
