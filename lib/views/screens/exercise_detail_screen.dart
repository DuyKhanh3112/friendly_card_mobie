// ignore_for_file: invalid_use_of_protected_member, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:friendly_card_mobile/components/custom_button.dart';
import 'package:friendly_card_mobile/controllers/exercise_controller.dart';
import 'package:friendly_card_mobile/controllers/question_controller.dart';
import 'package:friendly_card_mobile/models/exercise_detail.dart';
import 'package:friendly_card_mobile/models/option.dart';
import 'package:friendly_card_mobile/models/question.dart';
import 'package:friendly_card_mobile/utils/app_color.dart';
import 'package:friendly_card_mobile/widget/loading_page.dart';
import 'package:get/get.dart';

class ExerciseDetailScreen extends StatelessWidget {
  const ExerciseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ExerciseController exerciseController = Get.find<ExerciseController>();

    Rx<Question> question = Question.initQuestion().obs;
    RxList<Option> options = <Option>[].obs;
    Rx<String> selectedOption = ''.obs;

    // RxInt index = exerciseController.listDetailForExe.value
    //     .indexOf(exerciseController.exerciseDetail.value)
    //     .obs;
    loadData(question, exerciseController, options, selectedOption);
    return Obx(() {
      return exerciseController.loading.value
          ? LoadingPage()
          : Scaffold(
              appBar: AppBar(
                title: Text(
                  'Chi tiết bài tập ${exerciseController.listDetailForExe.value.indexOf(exerciseController.exerciseDetail.value) + 1}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.drakBlue,
                      ),
                ),
                backgroundColor: AppColor.skyBlue,
                foregroundColor: AppColor.drakBlue,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    exerciseController.loading.value = true;
                    exerciseController.listDetailChange.refresh();
                    exerciseController.loading.value = false;
                    Get.back();
                  },
                ),
              ),
              body: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.02,
                  vertical: Get.height * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Card(
                        elevation: 8,
                        clipBehavior: Clip.antiAlias,
                        margin:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          height: Get.height * 0.6,
                          width: Get.width * 0.8,
                          margin: EdgeInsets.all(Get.width * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.value.content,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColor.drakBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                              ),
                              Text(
                                '(${question.value.mean})',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColor.drakBlue,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: Get.height * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: options
                                      .map(
                                        (option) => ListTile(
                                          onTap: () {
                                            selectedOption.value =
                                                option.content;
                                            ExerciseDetail detail = [
                                                  ...exerciseController
                                                      .listDetailChange.value,
                                                  ...exerciseController
                                                      .listDetailForExe.value,
                                                ].firstWhereOrNull((d) =>
                                                    d.question_id ==
                                                    question.value.id) ??
                                                ExerciseDetail(
                                                  id: '',
                                                  exercise_id:
                                                      exerciseController
                                                          .exerciseDetail
                                                          .value
                                                          .exercise_id,
                                                  question_id:
                                                      question.value.id,
                                                  is_done: true,
                                                  anwer: '',
                                                );

                                            exerciseController
                                                .listDetailChange.value
                                                .removeWhere((c) =>
                                                    c.id == detail.id &&
                                                    c.question_id ==
                                                        question.value.id);

                                            detail.anwer = option.content;
                                            exerciseController
                                                .listDetailChange.value
                                                .add(detail);
                                          },
                                          leading: selectedOption.value ==
                                                  option.content
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: AppColor.drakBlue,
                                                )
                                              : Icon(
                                                  Icons.circle_outlined,
                                                  color: AppColor.drakBlue,
                                                ),
                                          title: Row(
                                            children: [
                                              Text(
                                                '${String.fromCharCode(65 + options.indexOf(option))}. ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: AppColor.drakBlue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  option.content,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color:
                                                            AppColor.drakBlue,
                                                        fontSize: 16,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                              title: 'Trước',
                              bgColor: Colors.red,
                              onClicked: () async {
                                int index = exerciseController
                                    .listDetailForExe.value
                                    .indexOf(exerciseController
                                        .exerciseDetail.value);
                                if (index > 0) {
                                  exerciseController.exerciseDetail.value =
                                      exerciseController
                                          .listDetailForExe[index - 1];
                                  loadData(question, exerciseController,
                                      options, selectedOption);
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.3,
                            child: CustomButton(
                              title: 'Sau',
                              bgColor: Colors.green,
                              onClicked: () async {
                                int index = exerciseController
                                    .listDetailForExe.value
                                    .indexOf(exerciseController
                                        .exerciseDetail.value);
                                if (index <
                                    exerciseController
                                            .listDetailForExe.value.length -
                                        1) {
                                  exerciseController.exerciseDetail.value =
                                      exerciseController
                                          .listDetailForExe[index + 1];
                                  loadData(question, exerciseController,
                                      options, selectedOption);
                                }
                              },
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

  void loadData(Rx<Question> question, ExerciseController exerciseController,
      RxList<Option> options, Rx<String> selectedOption) {
    question.value = Get.find<QuestionController>()
            .listQuestion
            .value
            .firstWhereOrNull((q) =>
                q.id == exerciseController.exerciseDetail.value.question_id) ??
        Question.initQuestion();
    options.value = Get.find<QuestionController>()
        .listOption
        .value
        .where((o) =>
            o.question_id ==
            exerciseController.exerciseDetail.value.question_id)
        .toList();

    selectedOption.value = [
              ...exerciseController.listDetailChange.value,
              ...exerciseController.listDetailForExe.value,
            ]
                .firstWhereOrNull((d) => d.question_id == question.value.id)
                ?.anwer !=
            null
        ? [
            ...exerciseController.listDetailChange.value,
            ...exerciseController.listDetailForExe.value,
          ].firstWhereOrNull((d) => d.question_id == question.value.id)!.anwer
        : '';
  }
}
