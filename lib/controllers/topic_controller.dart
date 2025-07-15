import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:friendly_card_mobie/models/topic.dart';
import 'package:get/get.dart';

class TopicController extends GetxController {
  RxBool loading = false.obs;
  CollectionReference topicCollection =
      FirebaseFirestore.instance.collection('topic');

  RxList<Topic> listTopics = <Topic>[].obs;
  UsersController usersController = Get.find<UsersController>();

  Future<void> loadTopic() async {
    loading.value = true;
    listTopics.value = [];
    var snapshort =
        await topicCollection.where('status', isEqualTo: 'active').get();
    for (var item in snapshort.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listTopics.value.add(Topic.fromJson(data));
    }
    loading.value = false;
  }
}
