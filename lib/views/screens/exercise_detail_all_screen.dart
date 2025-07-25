// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:friendly_card_mobile/components/custom_button.dart';
import 'package:friendly_card_mobile/controllers/exercise_controller.dart';
import 'package:friendly_card_mobile/models/exercise_detail.dart';
import 'package:friendly_card_mobile/utils/app_color.dart';
import 'package:friendly_card_mobile/widget/loading_page.dart';
import 'package:get/get.dart';

class ExerciseDetailAllScreen extends StatelessWidget {
  const ExerciseDetailAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ExerciseController exerciseController = Get.find<ExerciseController>();
    return Obx(() {
      return exerciseController.loading.value
          ? LoadingPage()
          : Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: exerciseController.listDetailForExe
                            // .where((detail) =>
                            //     detail.exercise_id ==
                            //     exerciseController.exercise.value.id)
                            .toList()
                            .map(
                          (exercise) {
                            int index = exerciseController
                                .listDetailForExe.value
                                .indexOf(exercise);
                            var anwer = [
                                  ...exerciseController.listDetailChange,
                                  ...exerciseController.listDetailForExe,
                                ].firstWhereOrNull((d) =>
                                    d.question_id == exercise.question_id) ??
                                ExerciseDetail.initExerciseDetail();
                            return ListTile(
                              leading: Icon(
                                exercise.is_done
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: AppColor.drakBlue,
                              ),
                              title: Text(
                                'Bài tập ${index + 1}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.drakBlue,
                                    ),
                              ),
                              subtitle: Text(
                                anwer.anwer != ''
                                    ? 'Đã hoàn thành'
                                    : 'Chưa hoàn thành',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColor.drakBlue,
                                    ),
                              ),
                              onTap: () {
                                exerciseController.exerciseDetail.value =
                                    exercise;
                                Get.toNamed('exercise_detail');
                              },
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    Container(
                      width: Get.width * 0.8,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Get.width * 0.3,
                            child: CustomButton(
                              title: 'Thoát',
                              bgColor: Colors.red,
                              onClicked: () async {
                                Get.back();
                              },
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.3,
                            child: CustomButton(
                              title: 'Tiếp tục',
                              bgColor: Colors.green,
                              onClicked: () async {},
                            ),
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
