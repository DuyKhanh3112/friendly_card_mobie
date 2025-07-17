// ignore_for_file: avoid_unnecessary_containers

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:friendly_card_mobie/controllers/topic_controller.dart';
import 'package:friendly_card_mobie/controllers/vocabulary_controller.dart';
import 'package:friendly_card_mobie/models/vocabulary.dart';
import 'package:friendly_card_mobie/utils/app_color.dart';
import 'package:friendly_card_mobie/widget/loading_page.dart';
import 'package:get/get.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VocabularyController vocabularyController =
        Get.find<VocabularyController>();
    TopicController topicController = Get.find<TopicController>();
    RxList<Vocabulary> listVocabulary = <Vocabulary>[].obs;
    Rx<Vocabulary> vocabulary = Vocabulary.initVocabulary().obs;
    RxBool isFront = true.obs;

    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    RxBool hideVoice = false.obs;

    return Obx(() {
      listVocabulary.value = vocabularyController.listVocabulary.value
          .where((voca) =>
              !voca.is_studied &&
              voca.topic_id == topicController.topic.value.id)
          .toList();
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
                    children: [
                      listVocabulary.value.isEmpty
                          ? SizedBox()
                          : Center(
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  FlipCard(
                                    key: cardKey,
                                    flipOnTouch: true,
                                    onFlipDone: (value) {
                                      hideVoice.value = false;
                                    },
                                    onFlip: () async {
                                      hideVoice.value = true;
                                    },
                                    front: Container(
                                      child: frontCard(
                                          listVocabulary, isFront, context),
                                    ),
                                    back: Container(
                                      child: backCard(
                                          listVocabulary, isFront, context),
                                    ),
                                  ),
                                  hideVoice.value
                                      ? SizedBox()
                                      : Container(
                                          margin:
                                              EdgeInsets.all(Get.width * 0.02),
                                          child: Icon(
                                            Icons.volume_down_alt,
                                            size: 32,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
    });
  }

  Widget frontCard(
      RxList<Vocabulary> listVocabulary, RxBool isFront, BuildContext context) {
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
              listVocabulary.value.first.image,
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
                      listVocabulary.value.first.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.drakBlue,
                            fontSize: 26,
                          ),
                    ),
                    Text(
                      listVocabulary.value.first.transcription,
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
                      'Example: ${listVocabulary.value.first.example}',
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

  Widget backCard(
      RxList<Vocabulary> listVocabulary, RxBool isFront, BuildContext context) {
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
              listVocabulary.value.first.image,
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
                      listVocabulary.value.first.mean,
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
                      'Ví dụ: ${listVocabulary.value.first.mean_example}',
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
