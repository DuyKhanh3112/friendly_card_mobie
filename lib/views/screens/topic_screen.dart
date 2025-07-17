// ignore_for_file: invalid_use_of_protected_member, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:friendly_card_mobie/controllers/main_controller.dart';
import 'package:friendly_card_mobie/controllers/topic_controller.dart';
import 'package:friendly_card_mobie/controllers/vocabulary_controller.dart';
import 'package:friendly_card_mobie/models/topic.dart';
import 'package:friendly_card_mobie/widget/header.dart';
import 'package:friendly_card_mobie/widget/loading_page.dart';
import 'package:get/get.dart';

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TopicController topicController = Get.find<TopicController>();
    VocabularyController vocabularyController =
        Get.find<VocabularyController>();
    MainController mainController = Get.find<MainController>();

    RxList<Topic> listTopic = <Topic>[].obs;

    return Obx(() {
      listTopic.value = topicController.listTopics.value;
      listTopic.value.sort((b, a) =>
          vocabularyController.listVocabulary.value
              .where((voca) => voca.topic_id == a.id && voca.is_studied)
              .length -
          vocabularyController.listVocabulary.value
              .where((voca) => voca.topic_id == b.id && voca.is_studied)
              .length);

      return mainController.loading.value
          ? LoadingPage()
          : Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.03,
                    vertical: Get.height * 0.02,
                  ),
                  child: Column(
                    children: [
                      HeaderWidget(),
                      Expanded(
                          child: ListView(
                        children: listTopic.value
                            .map((item) => buildCourseCard(context, item))
                            .toList(),
                      ))
                    ],
                  ),
                ),
              ),
            );
    });
  }

  Widget buildCourseCard(BuildContext context, Topic topic) {
    RxInt completed = 0.obs;
    RxInt total = 1.obs;
    return Obx(() {
      total.value = Get.find<VocabularyController>()
          .listVocabulary
          .value
          .where((voca) => voca.topic_id == topic.id)
          .length;
      completed.value = Get.find<VocabularyController>()
          .listVocabulary
          .value
          .where((voca) => voca.is_studied && voca.topic_id == topic.id)
          .length;
      return Container(
        // width: Get.width * 0.75,
        height: Get.height * 0.25,
        margin: EdgeInsets.symmetric(
          vertical: Get.height * 0.01,
        ),
        child: Card(
          elevation: 2.0,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.network(
                topic.image,
                width: Get.width,
                fit: BoxFit.cover,
              ),
              // Lớp phủ màu đen mờ để chữ nổi bật
              Container(
                height: Get.height * 0.2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      topic.name.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      'Đã học ${completed.value}/${total.value} từ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    LinearProgressIndicator(
                      value: completed.value / total.value,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
