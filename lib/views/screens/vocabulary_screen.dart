// ignore_for_file: avoid_unnecessary_containers

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:friendly_card_mobie/components/custom_button.dart';
import 'package:friendly_card_mobie/controllers/topic_controller.dart';
import 'package:friendly_card_mobie/controllers/vocabulary_controller.dart';
import 'package:friendly_card_mobie/models/vocabulary.dart';
import 'package:friendly_card_mobie/utils/app_color.dart';
import 'package:friendly_card_mobie/utils/tool.dart';
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

    RxBool hideVoice = false.obs;
    listVocabulary.value = vocabularyController.listVocabulary.value
        .where((voca) =>
            !voca.is_studied && voca.topic_id == topicController.topic.value.id)
        .toList();
    RxInt currentIndex = 0.obs;
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    // Rx<FlipCardController> flip_card_controller = FlipCardController().obs;
    return Obx(() {
      // print(cardKey)
      vocabulary.value = listVocabulary.value[currentIndex.value];
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
                      listVocabulary.value.isEmpty
                          ? SizedBox()
                          : Center(
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  FlipCard(
                                    key: cardKey,
                                    // controller: flip_card_controller.value,
                                    flipOnTouch: true,
                                    onFlipDone: (value) {
                                      hideVoice.value = false;
                                    },
                                    onFlip: () async {
                                      hideVoice.value = true;
                                    },
                                    front: Container(
                                      child: frontCard(
                                          vocabulary.value, isFront, context),
                                    ),
                                    back: Container(
                                      child: backCard(
                                          vocabulary.value, isFront, context),
                                    ),
                                  ),
                                  hideVoice.value
                                      ? SizedBox()
                                      : InkWell(
                                          onTap: () async {
                                            await Tool.textToSpeak(
                                                vocabulary.value.name);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(
                                                Get.width * 0.02),
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
                          Container(
                            width: Get.width * 0.3,
                            child: CustomButton(
                              title: 'Trước',
                              onClicked: currentIndex > 0
                                  ? () async {
                                      // vocabulary.value = listVocabulary[1];
                                      currentIndex.value =
                                          currentIndex.value - 1;
                                      cardKey = GlobalKey<FlipCardState>();
                                    }
                                  : null,
                            ),
                          ),
                          Container(
                            width: Get.width * 0.3,
                            child: CustomButton(
                              title: 'Tiếp theo',
                              onClicked:
                                  currentIndex < listVocabulary.value.length - 1
                                      ? () async {
                                          // vocabulary.value = listVocabulary[1];
                                          currentIndex.value =
                                              currentIndex.value + 1;
                                          cardKey = GlobalKey<FlipCardState>();
                                        }
                                      : null,
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

  Widget frontCard(
      Vocabulary vocabulary, RxBool isFront, BuildContext context) {
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
              vocabulary.image,
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
                      vocabulary.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.drakBlue,
                            fontSize: 26,
                          ),
                    ),
                    Text(
                      vocabulary.transcription,
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
                      'Example: ${vocabulary.example}',
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

  Widget backCard(Vocabulary vocabulary, RxBool isFront, BuildContext context) {
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
              vocabulary.image,
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
                      vocabulary.mean,
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
                      'Ví dụ: ${vocabulary.mean_example}',
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
