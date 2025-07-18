import 'package:flutter/widgets.dart';
import 'package:friendly_card_mobile/controllers/study_history_controller.dart';
import 'package:friendly_card_mobile/controllers/topic_controller.dart';
import 'package:friendly_card_mobile/views/screens/home_screen.dart';
import 'package:friendly_card_mobile/views/screens/topic_screen.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt currentPage = 0.obs;
  RxBool loading = false.obs;

  List<Widget> pages = [
    HomeScreen(),
    TopicScreen(),
    TopicScreen(),
    HomeScreen(),
  ];

  Future<void> loadData() async {
    loading.value = true;
    Get.find<StudyHistoryController>().listHistory.value = [];
    await Get.find<TopicController>().loadTopic();
    // print(Get.find<StudyHistoryController>().listHistory.value.length);
    loading.value = false;
  }
}
