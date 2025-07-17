import 'package:flutter/widgets.dart';
import 'package:friendly_card_mobie/controllers/study_history_controller.dart';
import 'package:friendly_card_mobie/controllers/topic_controller.dart';
import 'package:friendly_card_mobie/views/screens/home_screen.dart';
import 'package:friendly_card_mobie/views/screens/topic_screen.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt currentPage = 0.obs;
  RxBool loading = false.obs;

  List<Widget> pages = [
    HomeScreen(),
    TopicScreen(),
    HomeScreen(),
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
