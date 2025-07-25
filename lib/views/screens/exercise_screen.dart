// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:friendly_card_mobile/components/custom_button.dart';
import 'package:friendly_card_mobile/controllers/exercise_controller.dart';
import 'package:friendly_card_mobile/controllers/topic_controller.dart';
import 'package:friendly_card_mobile/models/exercise.dart';
import 'package:friendly_card_mobile/utils/app_color.dart';
import 'package:friendly_card_mobile/utils/tool.dart';
import 'package:friendly_card_mobile/widget/loading_page.dart';
import 'package:get/get.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TopicController topicController = Get.find<TopicController>();
    ExerciseController exerciseController = Get.find<ExerciseController>();
    return Obx(() {
      return exerciseController.loading.value
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
              body: Column(
                children: [
                  //header
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.025,
                      vertical: Get.height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.drakBlue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: Get.width * 0.15,
                          height: Get.height * 0.05,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'STT',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.white,
                                    ),
                          ),
                        ),
                        Container(
                          width: Get.width * 0.25,
                          height: Get.height * 0.05,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Thời gian',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.white,
                                    ),
                          ),
                        ),
                        Container(
                          width: Get.width * 0.3,
                          height: Get.height * 0.05,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Trạng thái',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.white,
                                    ),
                          ),
                        ),
                        Container(
                          width: Get.width * 0.25,
                          height: Get.height * 0.05,
                          decoration: BoxDecoration(),
                          alignment: Alignment.center,
                          child: Text(
                            'Kết quả',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.white,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      children: exerciseController.listExercises.value
                          .map((exercise) {
                        return exerciseItem(
                            context,
                            exercise,
                            exerciseController.listExercises.value
                                    .indexOf(exercise) +
                                1);
                      }).toList(),
                    ),
                  ),
                ],
              ),
              floatingActionButton: exerciseController.listExercises.value
                      .where((e) => e.done != true)
                      .isNotEmpty
                  ? null
                  : SizedBox(
                      width: Get.width * 0.925,
                      child: CustomButton(
                        title: 'Tạo bài tập',
                        onClicked: () async {
                          await exerciseController.createExercise();
                        },
                      ),
                    ),
            );
    });
  }

  Container exerciseItem(BuildContext context, Exercise exercise, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.005,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * 0.025,
        vertical: Get.height * 0.01,
      ),
      decoration: BoxDecoration(
        color: exercise.done ? AppColor.royalBlue : AppColor.lightBlue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Container(
            width: Get.width * 0.15,
            height: Get.height * 0.05,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              index.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: exercise.done ? AppColor.white : AppColor.drakBlue,
                    fontSize: 14,
                  ),
            ),
          ),
          Container(
            width: Get.width * 0.25,
            height: Get.height * 0.05,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              Tool.formatTimestamp(exercise.create_at.millisecondsSinceEpoch),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: exercise.done ? AppColor.white : AppColor.drakBlue,
                    fontSize: 12,
                  ),
            ),
          ),
          Container(
            width: Get.width * 0.3,
            height: Get.height * 0.05,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: exercise.done
                ? Text(
                    'Hoàn thành',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                          fontSize: 14,
                        ),
                  )
                : TextButton(
                    onPressed: () {
                      Get.find<ExerciseController>()
                          .gotoExerciseDetailScreen(exercise);
                    },
                    child: Text(
                      'Tiếp tục',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.drakBlue,
                            fontSize: 14,
                          ),
                    )),
          ),
          Container(
            width: Get.width * 0.25,
            height: Get.height * 0.05,
            decoration: BoxDecoration(),
            alignment: Alignment.center,
            child: exercise.done
                ? Text(
                    'Kết quả',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: exercise.done
                              ? AppColor.white
                              : AppColor.drakBlue,
                          fontSize: 14,
                        ),
                  )
                : SizedBox(
                    width: Get.width * 0.05,
                    child: Divider(
                      color: AppColor.drakBlue,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
