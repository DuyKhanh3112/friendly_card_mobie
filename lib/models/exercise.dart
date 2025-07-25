// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String id;
  String topic_id;
  String user_id;
  Timestamp create_at;
  bool done;

  Exercise({
    required this.id,
    required this.topic_id,
    required this.user_id,
    required this.create_at,
    required this.done,
  });

  factory Exercise.initExercise() {
    return Exercise(
      id: '',
      topic_id: '',
      user_id: '',
      create_at: Timestamp.now(),
      done: false,
    );
  }

  static Exercise fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      topic_id: json['topic_id'],
      user_id: json['user_id'],
      create_at: json['create_at'],
      done: json['done'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic_id': topic_id,
      'user_id': user_id,
      'create_at': create_at,
      'done': done,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'topic_id': topic_id,
      'user_id': user_id,
      'create_at': create_at,
    };
  }
}
