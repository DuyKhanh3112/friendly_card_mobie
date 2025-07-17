// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_mobie/controllers/study_history_controller.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:friendly_card_mobie/controllers/vocabulary_controller.dart';
import 'package:friendly_card_mobie/models/study_history.dart';
import 'package:friendly_card_mobie/models/topic.dart';
import 'package:get/get.dart';

class TopicController extends GetxController {
  RxBool loading = false.obs;
  CollectionReference topicCollection =
      FirebaseFirestore.instance.collection('topic');

  // @override
  // void onInit() {
  //   super.onInit();
  //   topicCollection
  //       // .where('status', isEqualTo: 'active')
  //       .snapshots()
  //       .listen((snapshot) async {
  //     for (var item in snapshot.docChanges) {
  //       Map<String, dynamic> data = item.doc.data() as Map<String, dynamic>;
  //       data['id'] = item.doc.id;
  //       var topicItem = Topic.fromJson(data);
  //       if (topicItem.status == 'active') {
  //         await Get.find<VocabularyController>()
  //             .loadVocabularyTopic(topicItem.id);
  //         if (Get.find<VocabularyController>()
  //             .listVocabulary
  //             .value
  //             .where((voca) => voca.topic_id == item.doc.id)
  //             .isNotEmpty) {
  //           listTopics.value.add(Topic.fromJson(data));
  //         }
  //       } else {
  //         listTopics.value.removeWhere((t) => t.id == topicItem.id);
  //         Get.find<VocabularyController>()
  //             .listVocabulary
  //             .value
  //             .where((voca) => voca.id == topicItem.id);
  //       }
  //     }
  //   });
  // }

  RxList<Topic> listTopics = <Topic>[].obs;
  Rx<Topic> topic = Topic.initTopic().obs;

  // UsersController usersController = Get.find<UsersController>();

  Future<void> loadTopic() async {
    loading.value = true;
    listTopics.value = [];
    var snapshort =
        await topicCollection.where('status', isEqualTo: 'active').get();
    for (var item in snapshort.docs) {
      await Get.find<VocabularyController>().loadVocabularyTopic(item.id);
      if (Get.find<VocabularyController>()
          .listVocabulary
          .value
          .where((voca) => voca.topic_id == item.id)
          .isNotEmpty) {
        Map<String, dynamic> data = item.data() as Map<String, dynamic>;
        data['id'] = item.id;
        listTopics.value.add(Topic.fromJson(data));
      }
    }
    loading.value = false;
  }

  List<Topic> getListTopicContinute() {
    List<Topic> listContinute = [];
    for (var topic in listTopics.value) {
      List<String> listVocabulary = Get.find<VocabularyController>()
          .listVocabulary
          .value
          .where((voca) => topic.id == voca.topic_id)
          .map((voca) => voca.id)
          .toList();
      List<StudyHistory> listHistory = Get.find<StudyHistoryController>()
          .listHistory
          .value
          .where((history) => listVocabulary.contains(history.vocabulary_id))
          .toList();
      if (listHistory.isNotEmpty) {
        listContinute.add(topic);
      }
    }
    return listContinute;
  }

  List<Topic> getListTopicSugguest() {
    List<Topic> listContinute = [];
    for (var topic in listTopics.value) {
      List<String> listVocabulary = Get.find<VocabularyController>()
          .listVocabulary
          .value
          .where((voca) => topic.id == voca.topic_id)
          .map((voca) => voca.id)
          .toList();
      List<StudyHistory> listHistory = Get.find<StudyHistoryController>()
          .listHistory
          .value
          .where((history) => listVocabulary.contains(history.vocabulary_id))
          .toList();
      if (listHistory.isEmpty) {
        listContinute.add(topic);
      }
    }
    return listContinute;
  }

  void listenUpdateToTopic() {
    topicCollection
        .where('status', isEqualTo: 'active')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      listTopics.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Topic.fromJson(data);
      }).toList();
    });
  }
}
