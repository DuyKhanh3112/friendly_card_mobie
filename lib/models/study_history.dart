// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class StudyHistory {
  String id;
  String vocabulary_id;
  String user_id;
  Timestamp study_at;

  StudyHistory({
    required this.id,
    required this.vocabulary_id,
    required this.user_id,
    required this.study_at,
  });

  factory StudyHistory.initStudyHistory() {
    return StudyHistory(
      id: '',
      vocabulary_id: '',
      user_id: '',
      study_at: Timestamp.now(),
    );
  }

  static StudyHistory fromJson(Map<String, dynamic> json) {
    return StudyHistory(
      id: json['id'],
      vocabulary_id: json['vocabulary_id'],
      user_id: json['user_id'],
      study_at: json['study_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vocabulary_id': vocabulary_id,
      'user_id': user_id,
      'study_at': study_at,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'vocabulary_id': vocabulary_id,
      'user_id': user_id,
      'study_at': study_at,
    };
  }
}
