// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  String id;
  String user_id;
  String name;
  Timestamp update_at;
  String status;
  String image;
  // num num_vocabulary;
  // num num_studied;

  Topic({
    required this.id,
    required this.user_id,
    required this.name,
    required this.update_at,
    required this.status,
    required this.image,
    // required this.num_vocabulary,
    // required this.num_studied,
  });

  factory Topic.initTopic() {
    return Topic(
      id: '',
      name: '',
      user_id: '',
      update_at: Timestamp.now(),
      status: 'draft',
      image: '',
      // num_vocabulary: 0,
      // num_studied: 0,
    );
  }

  static Topic fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
      user_id: json['user_id'],
      status: json['status'],
      update_at: json['update_at'],
      image: json['image'],
      // num_vocabulary: json['num_vocabulary'] ?? 0,
      // num_studied: json['num_studied'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_id': user_id,
      'status': status,
      'update_at': update_at,
      'image': image,
      // 'num_vocabulary': num_vocabulary,
      // 'num_studied': num_studied
    };
  }

  Map<String, dynamic> toVal() {
    return {
      'name': name,
      'user_id': user_id,
      'status': status,
      'update_at': update_at,
      'image': image,
    };
  }
}
