import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_mobie/models/vocabulary.dart';
import 'package:get/get.dart';

class VocabularyController extends GetxController {
  RxBool loading = false.obs;

  CollectionReference vocabularyCollection =
      FirebaseFirestore.instance.collection('vocabulary');
  RxList<Vocabulary> listVocabulary = <Vocabulary>[].obs;
}
