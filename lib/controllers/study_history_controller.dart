// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:friendly_card_mobie/models/study_history.dart';
import 'package:get/get.dart';

class StudyHistoryController extends GetxController {
  RxBool loading = false.obs;
  CollectionReference studyHistoryCollection =
      FirebaseFirestore.instance.collection('study_history');

  RxList<StudyHistory> listHistory = <StudyHistory>[].obs;

  Future<bool> checkStudied(String vocaID) async {
    UsersController usersController = Get.find<UsersController>();
    var snapshort = await studyHistoryCollection
        .where('vocabulary_id', isEqualTo: vocaID)
        .where('user_id', isEqualTo: usersController.user.value.id)
        .get();
    for (var item in snapshort.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listHistory.value.add((StudyHistory.fromJson(data)));
    }
    return snapshort.docs.isNotEmpty;
  }

  int countStudyToday() {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));
    return listHistory.value
        .where((history) =>
            history.study_at.toDate().isAfter(startOfDay) &&
            history.study_at.toDate().isBefore(endOfDay))
        .length;
  }
}
