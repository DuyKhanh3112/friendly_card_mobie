import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_mobile/controllers/topic_controller.dart';
import 'package:friendly_card_mobile/models/option.dart';
import 'package:friendly_card_mobile/models/question.dart';
import 'package:get/get.dart';

class QuestionController extends GetxController {
  RxBool loading = false.obs;

  CollectionReference questionCollection =
      FirebaseFirestore.instance.collection('question');
  CollectionReference optionCollection =
      FirebaseFirestore.instance.collection('option');

  RxList<Question> listQuestion = <Question>[].obs;
  RxList<Option> listOption = <Option>[].obs;

  Future<void> fetchQuestions() async {
    loading.value = true;
    listQuestion.value = [];
    listOption.value = [];
    var snapshot = await questionCollection
        .where('topic_id',
            isEqualTo: Get.find<TopicController>().topic.value.id)
        .get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      await fetchOptions(data['id']);
      listQuestion.add(Question.fromJson(data));
    }
    loading.value = false;
  }

  Future<void> fetchOptions(String questionId) async {
    loading.value = true;
    var snapshot = await optionCollection
        .where('question_id', isEqualTo: questionId)
        .get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      listOption.add(Option.fromJson(data));
    }
    loading.value = false;
  }
}
