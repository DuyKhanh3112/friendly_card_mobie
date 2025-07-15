import 'package:friendly_card_mobie/controllers/topic_controller.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt currentPage = 0.obs;
  RxBool loading = false.obs;

  Future<void> loadData() async {
    loading.value = true;
    await Get.find<TopicController>().loadTopic();
    loading.value = false;
  }
}
