// ignore_for_file: avoid_unnecessary_containers, invalid_use_of_protected_member, sized_box_for_whitespace

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:friendly_card_mobile/components/custom_button.dart';
import 'package:friendly_card_mobile/controllers/topic_controller.dart';
import 'package:friendly_card_mobile/controllers/vocabulary_controller.dart';
import 'package:friendly_card_mobile/models/vocabulary.dart';
import 'package:friendly_card_mobile/utils/app_color.dart';
import 'package:friendly_card_mobile/utils/tool.dart';
import 'package:friendly_card_mobile/widget/loading_page.dart';
import 'package:get/get.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VocabularyController vocabularyController =
        Get.find<VocabularyController>();
    TopicController topicController = Get.find<TopicController>();
    RxBool isFront = true.obs;

    RxBool hideVoice = false.obs;
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

    RxBool canBack = false.obs;
    RxBool canContinute = false.obs;
    return Obx(() {
      canBack.value = !(vocabularyController.listStudied.value.first.id ==
          vocabularyController.vocabulary.value.id);
      canContinute.value = !(vocabularyController.listVocaAllow.value.isEmpty &&
          (vocabularyController.listStudied.value.lastOrNull ??
                      Vocabulary.initVocabulary())
                  .id ==
              vocabularyController.vocabulary.value.id);
      return vocabularyController.loading.value
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
                    vertical: Get.height * 0.03,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            FlipCard(
                              key: cardKey,
                              flipOnTouch: true,
                              onFlipDone: (value) {
                                hideVoice.value = false;
                                isFront.value = !isFront.value;
                              },
                              onFlip: () async {
                                hideVoice.value = true;
                              },
                              front: Container(
                                child: frontCard(context),
                              ),
                              back: Container(
                                child: backCard(context),
                              ),
                            ),
                            hideVoice.value
                                ? SizedBox()
                                : InkWell(
                                    onTap: () async {
                                      await Tool.textToSpeak(
                                        isFront.value
                                            ? Get.find<VocabularyController>()
                                                .vocabulary
                                                .value
                                                .name
                                            : Get.find<VocabularyController>()
                                                .vocabulary
                                                .value
                                                .mean,
                                        isFront.value ? 'en-US' : 'vi-VN',
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(Get.width * 0.02),
                                      child: Icon(
                                        Icons.volume_down_alt,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          !canBack.value
                              ? SizedBox()
                              : Container(
                                  width: Get.width * 0.3,
                                  child: CustomButton(
                                    title: 'Trước',
                                    onClicked: () async {
                                      cardKey = GlobalKey<FlipCardState>();
                                      isFront.value = true;
                                      await vocabularyController
                                          .backVocabulary();
                                    },
                                  ),
                                ),
                          !canContinute.value
                              ? SizedBox()
                              : Container(
                                  width: Get.width * 0.3,
                                  child: CustomButton(
                                    title: 'Tiếp theo',
                                    onClicked: () async {
                                      cardKey = GlobalKey<FlipCardState>();
                                      isFront.value = true;
                                      await vocabularyController
                                          .continuteVocabulary();
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }

  Widget frontCard(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: Get.width * 0.85,
        height: Get.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              Get.find<VocabularyController>().vocabulary.value.image,
              width: Get.width,
              height: Get.height * 0.4,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                height: Get.height * 0.15,
                margin: EdgeInsets.all(
                  Get.width * 0.05,
                ),
                child: ListView(
                  children: [
                    Text(
                      Get.find<VocabularyController>().vocabulary.value.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.drakBlue,
                            fontSize: 26,
                          ),
                    ),
                    Text(
                      Get.find<VocabularyController>()
                          .vocabulary
                          .value
                          .transcription,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            // fontWeight:
                            //     FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: AppColor.drakBlue,
                            fontSize: 26,
                          ),
                    ),
                    Text(
                      'Example: ${Get.find<VocabularyController>().vocabulary.value.example}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            // fontStyle: FontStyle.italic,
                            color: AppColor.drakBlue,
                            // fontSize: 26,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: Get.width * 0.85,
              decoration: BoxDecoration(
                color: AppColor.skyBlue,
              ),
              alignment: Alignment.center,
              child: Text(
                'Click to flip the card',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: AppColor.drakBlue,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget backCard(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: Get.width * 0.85,
        height: Get.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              Get.find<VocabularyController>().vocabulary.value.image,
              width: Get.width,
              height: Get.height * 0.4,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                height: Get.height * 0.15,
                margin: EdgeInsets.all(
                  Get.width * 0.05,
                ),
                child: ListView(
                  children: [
                    Text(
                      Get.find<VocabularyController>().vocabulary.value.mean,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.drakBlue,
                            fontSize: 26,
                          ),
                    ),
                    Text(
                      '',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            // fontWeight:
                            //     FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: AppColor.drakBlue,
                            fontSize: 26,
                          ),
                    ),
                    Text(
                      'Ví dụ: ${Get.find<VocabularyController>().vocabulary.value.mean_example}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            // fontStyle: FontStyle.italic,
                            color: AppColor.drakBlue,
                            // fontSize: 26,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: Get.width * 0.85,
              decoration: BoxDecoration(
                color: AppColor.skyBlue,
              ),
              alignment: Alignment.center,
              child: Text(
                'Nhấn vào để lật thẻ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: AppColor.drakBlue,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
