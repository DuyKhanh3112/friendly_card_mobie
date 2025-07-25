// ignore_for_file: non_constant_identifier_names

class ExerciseDetail {
  String id;
  String exercise_id;
  String question_id;
  String anwer;
  bool is_done;

  ExerciseDetail({
    required this.id,
    required this.exercise_id,
    required this.question_id,
    required this.is_done,
    required this.anwer,
  });

  factory ExerciseDetail.initExerciseDetail() {
    return ExerciseDetail(
      id: '',
      exercise_id: '',
      question_id: '',
      anwer: '',
      is_done: false,
    );
  }

  static ExerciseDetail fromJson(Map<String, dynamic> json) {
    return ExerciseDetail(
      id: json['id'],
      exercise_id: json['exercise_id'],
      question_id: json['question_id'],
      anwer: json['anwer'] ?? '',
      is_done: json['is_done'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise_id': exercise_id,
      'question_id': question_id,
      'anwer': anwer,
      'is_done': is_done,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'exercise_id': exercise_id,
      'question_id': question_id,
      'anwer': anwer,
      'is_done': is_done,
    };
  }
}
