// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_mobile/controllers/study_history_controller.dart';
import 'package:friendly_card_mobile/controllers/topic_controller.dart';
import 'package:friendly_card_mobile/controllers/users_controller.dart';
import 'package:friendly_card_mobile/models/study_history.dart';
import 'package:friendly_card_mobile/models/topic.dart';
import 'package:friendly_card_mobile/models/vocabulary.dart';
import 'package:get/get.dart';

class VocabularyController extends GetxController {
  RxBool loading = false.obs;

  CollectionReference vocabularyCollection =
      FirebaseFirestore.instance.collection('vocabulary');
  CollectionReference studyHistoryCollection =
      FirebaseFirestore.instance.collection('study_history');

  RxList<Vocabulary> listVocabulary = <Vocabulary>[].obs;
  Rx<Vocabulary> vocabulary = Vocabulary.initVocabulary().obs;
  RxList<Vocabulary> listStudied = <Vocabulary>[].obs;
  RxList<Vocabulary> listVocaAllow = <Vocabulary>[].obs;

  UsersController usersController = Get.find<UsersController>();

  Future<void> gotoAllVocabulary(Topic topic) async {
    Get.find<TopicController>().loading.value = true;
    Get.find<TopicController>().topic.value = topic;
    listVocaAllow.value = listVocabulary.value
        .where((voca) => !voca.is_studied && voca.topic_id == topic.id)
        .toList();
    listStudied.value = listVocabulary.value
        .where((voca) => voca.is_studied && voca.topic_id == topic.id)
        .toList();
    Get.toNamed('/all_vocabulary');
    Get.find<TopicController>().loading.value = false;
  }

  Future<void> startStudy(Topic topic) async {
    Get.find<TopicController>().loading.value = true;
    Get.find<TopicController>().topic.value = topic;
    listVocaAllow.value = listVocabulary.value
        .where((voca) => !voca.is_studied && voca.topic_id == topic.id)
        .toList();

    await studyVocabulary(listVocaAllow.value.first);
    listStudied.value.add(listVocaAllow.value.first);
    listVocaAllow.value.removeAt(0);
    vocabulary.value = listStudied.value.last;
    Get.toNamed('/vocabulary');
    Get.find<TopicController>().loading.value = false;
  }

  Future<void> gotoVocabulary(Vocabulary voca) async {
    vocabulary.value = voca;
    Get.toNamed('/vocabulary');
    Get.find<TopicController>().loading.value = false;
  }

  Future<void> backVocabulary() async {
    loading.value = true;
    var index = listStudied.value
        .map((voca) => voca.id)
        .toList()
        .indexOf(vocabulary.value.id);
    vocabulary.value = listStudied.value[index - 1];
    loading.value = false;
  }

  Future<void> continuteVocabulary() async {
    loading.value = true;
    var index = 0;
    if (vocabulary.value.id == listStudied.value.last.id) {
      await studyVocabulary(listVocaAllow.value.first);
      listStudied.value.add(listVocaAllow.value.first);
      listVocaAllow.value.removeAt(0);
      vocabulary.value = listStudied.value.last;
    } else {
      index = listStudied.value
          .map((voca) => voca.id)
          .toList()
          .indexOf(vocabulary.value.id);
      vocabulary.value = listStudied.value[index + 1];
    }
    loading.value = false;
  }

  Future<void> studyVocabulary(Vocabulary voca) async {
    voca.is_studied = true;
    listVocabulary.value =
        listVocabulary.value.map((v) => v.id == voca.id ? voca : v).toList();
    await vocabularyCollection.doc(voca.id).update(voca.toVal());
    var history = StudyHistory(
        id: '',
        vocabulary_id: voca.id,
        user_id: Get.find<UsersController>().user.value.id,
        study_at: Timestamp.now());

    WriteBatch batch = FirebaseFirestore.instance.batch();
    String historyID = studyHistoryCollection.doc().id;
    history.id = historyID;
    DocumentReference refHistory = studyHistoryCollection.doc(historyID);
    batch.set(refHistory, history.toVal());
    await batch.commit();
    Get.find<StudyHistoryController>().listHistory.value.add(history);
  }

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
