// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_mobile/controllers/question_controller.dart';
import 'package:friendly_card_mobile/controllers/topic_controller.dart';
import 'package:friendly_card_mobile/controllers/users_controller.dart';
import 'package:friendly_card_mobile/models/exercise.dart';
import 'package:friendly_card_mobile/models/exercise_detail.dart';
import 'package:friendly_card_mobile/models/question.dart';
import 'package:get/get.dart';

class ExerciseController extends GetxController {
  int limit = 10;
  RxBool loading = false.obs;

  CollectionReference exerciseCollection =
      FirebaseFirestore.instance.collection('exercises');
  CollectionReference exerciseDetailCollection =
      FirebaseFirestore.instance.collection('exercise_detail');

  RxList<Exercise> listExercises = <Exercise>[].obs;
  RxList<ExerciseDetail> listExerciseDetails = <ExerciseDetail>[].obs;

  Rx<Exercise> exercise = Exercise.initExercise().obs;
  Rx<ExerciseDetail> exerciseDetail = ExerciseDetail.initExerciseDetail().obs;

  RxList<ExerciseDetail> listDetailForExe = <ExerciseDetail>[].obs;
  RxList<ExerciseDetail> listDetailChange = <ExerciseDetail>[].obs;

  Future<void> gotoExerciseDetailScreen(Exercise exe) async {
    loading.value = true;
    listDetailChange.value = [];
    exercise.value = exe;
    listDetailForExe.value = listExerciseDetails
        .where((detail) => detail.exercise_id == exe.id)
        .toList();
    await Get.find<QuestionController>().fetchQuestions();
    loading.value = false;
    Get.toNamed('/exercise_detail_all');
  }

  Future<void> fetchExercises() async {
    loading.value = true;
    listExercises.value = [];
    listExerciseDetails.value = [];
    var snapshot = await exerciseCollection
        .where('topic_id',
            isEqualTo: Get.find<TopicController>().topic.value.id)
        .get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      await fetchExerciseDetails(data['id']);

      List<ExerciseDetail> detailNotDone = listExerciseDetails
          .where(
              (detail) => detail.exercise_id == data['id'] && !detail.is_done)
          .toList();
      data['done'] = detailNotDone.isEmpty;
      listExercises.add(Exercise.fromJson(data));
    }
    loading.value = false;
  }

  Future<void> fetchExerciseDetails(String exerciseId) async {
    loading.value = true;
    var snapshot = await exerciseDetailCollection
        .where('exercise_id', isEqualTo: exerciseId)
        .get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      listExerciseDetails.add(ExerciseDetail.fromJson(data));
    }
    loading.value = false;
  }

  Future<void> createExercise() async {
    loading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String id = exerciseCollection.doc().id;
    DocumentReference refExercise = exerciseCollection.doc(id);
    Exercise exercise = Exercise(
      id: id,
      topic_id: Get.find<TopicController>().topic.value.id,
      user_id: Get.find<UsersController>().user.value.id,
      create_at: Timestamp.now(),
      done: false,
    );
    batch.set(refExercise, exercise.toJson());
    await batch.commit();
    await createExerciseDetail(exercise);

    await fetchExercises();
    loading.value = false;
    await gotoExerciseDetailScreen(exercise);
  }

  Future<void> createExerciseDetail(Exercise exercise) async {
    loading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    Get.find<QuestionController>().listQuestion.value.shuffle();

    int end = limit < Get.find<QuestionController>().listQuestion.value.length
        ? limit
        : Get.find<QuestionController>().listQuestion.value.length;
    List<Question> questions = Get.find<QuestionController>()
        .listQuestion
        .value
        .getRange(0, end)
        .toList();
    for (var question in questions) {
      String id = exerciseDetailCollection.doc().id;
      DocumentReference refExerciseDetail = exerciseDetailCollection.doc(id);
      ExerciseDetail exerciseDetail = ExerciseDetail(
        id: id,
        exercise_id: exercise.id,
        question_id: question.id,
        is_done: false,
        anwer: '',
      );
      batch.set(refExerciseDetail, exerciseDetail.toJson());
    }
    await batch.commit();
    loading.value = false;
  }

  Future<void> deleteExercise(String exerciseId) async {
    loading.value = true;

    loading.value = false;
  }
}
