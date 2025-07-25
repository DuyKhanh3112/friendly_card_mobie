import 'package:friendly_card_mobile/controllers/exercise_controller.dart';
import 'package:friendly_card_mobile/controllers/main_controller.dart';
import 'package:friendly_card_mobile/controllers/question_controller.dart';
import 'package:friendly_card_mobile/controllers/study_history_controller.dart';
import 'package:friendly_card_mobile/controllers/topic_controller.dart';
import 'package:friendly_card_mobile/controllers/users_controller.dart';
import 'package:friendly_card_mobile/controllers/vocabulary_controller.dart';
import 'package:get/get.dart';

class InitalBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(MainController());
    Get.put(UsersController());
    Get.put(TopicController());
    Get.put(VocabularyController());
    Get.put(StudyHistoryController());
    Get.put(QuestionController());
    Get.put(ExerciseController());

    // print(await Get.find<UsersController>().getSession());
    // print('====');
    if (await Get.find<UsersController>().getSession() == null) {
      Get.toNamed('/login');
    } else {
      await Get.find<UsersController>().loginSession();
    }
  }
}
