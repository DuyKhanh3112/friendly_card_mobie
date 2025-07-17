// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_mobie/controllers/study_history_controller.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:friendly_card_mobie/models/vocabulary.dart';
import 'package:get/get.dart';

class VocabularyController extends GetxController {
  RxBool loading = false.obs;

  CollectionReference vocabularyCollection =
      FirebaseFirestore.instance.collection('vocabulary');
  CollectionReference studyHistoryCollection =
      FirebaseFirestore.instance.collection('study_history');

  RxList<Vocabulary> listVocabulary = <Vocabulary>[].obs;

  UsersController usersController = Get.find<UsersController>();

  Future<void> loadVocabularyTopic(String topicID) async {
    loading.value = true;
    listVocabulary.value.removeWhere((voca) => voca.topic_id == topicID);
    var snapshort = await vocabularyCollection
        .where('topic_id', isEqualTo: topicID)
        .where('status', isEqualTo: 'active')
        .get();
    for (var item in snapshort.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      data['is_studied'] =
          await Get.find<StudyHistoryController>().checkStudied(item.id);
      listVocabulary.value.add(Vocabulary.fromJson(data));
    }
    // listVocabulary.value.sort((a, b) => a.update_at.toDate().compareTo(b.update_at.toDate()));
    loading.value = false;
  }
}
