import 'package:friendly_card_mobie/controllers/main_controller.dart';
import 'package:friendly_card_mobie/controllers/topic_controller.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:friendly_card_mobie/controllers/vocabulary_controller.dart';
import 'package:get/get.dart';

class InitalBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(MainController());
    Get.put(UsersController());
    Get.put(TopicController());
    Get.put(VocabularyController());
  }
}
