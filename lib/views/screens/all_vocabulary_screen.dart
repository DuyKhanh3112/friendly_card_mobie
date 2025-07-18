// ignore_for_file: invalid_use_of_protected_member, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:friendly_card_mobie/controllers/topic_controller.dart';
import 'package:friendly_card_mobie/controllers/vocabulary_controller.dart';
import 'package:friendly_card_mobie/models/vocabulary.dart';
import 'package:friendly_card_mobie/utils/app_color.dart';
import 'package:friendly_card_mobie/widget/loading_page.dart';
import 'package:get/get.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';

class AllVocabularyScreen extends StatelessWidget {
  const AllVocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TopicController topicController = Get.find<TopicController>();
    VocabularyController vocabularyController =
        Get.find<VocabularyController>();
    return Obx(() {
      return topicController.loading.value || vocabularyController.loading.value
          ? LoadingPage()
          : Scaffold(
              appBar: AppBar(
                title: Text(
                  'Topic: ${topicController.topic.value.name.toUpperCase()}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.drakBlue,
                      ),
                ),
                backgroundColor: AppColor.skyBlue,
                foregroundColor: AppColor.drakBlue,
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.03,
                    // vertical: Get.height * 0.03,
                  ),
                  child: FlexibleGridView(
                      axisCount: GridLayoutEnum.twoElementsInRow,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: [
                        ...vocabularyController.listStudied.value,
                        ...vocabularyController.listVocaAllow.value
                      ]
                          .where((voca) =>
                              voca.topic_id == topicController.topic.value.id)
                          .map((item) {
                        return buildVocabularyCard(context, item);
                      }).toList()),
                ),
              ),
            );
    });
  }

  Widget buildVocabularyCard(BuildContext context, Vocabulary vocabulary) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Get.height * 0.01,
      ),
      child: Card(
        elevation: 2.0,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: vocabulary.is_studied
              ? () async {
                  await Get.find<VocabularyController>()
                      .gotoVocabulary(vocabulary);
                }
              : null,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  Image.network(
                    vocabulary.image,
                    // width: Get.width,
                    height: Get.height * 0.25,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          vocabulary.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: vocabulary.is_studied
                                        ? AppColor.drakBlue
                                        : Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Lớp phủ màu đen mờ để chữ nổi bật
              vocabulary.is_studied
                  ? SizedBox()
                  : Container(
                      height: Get.height * 0.30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
    // });
  }
}
