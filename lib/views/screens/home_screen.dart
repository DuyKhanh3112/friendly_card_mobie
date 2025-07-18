// ignore_for_file: invalid_use_of_protected_member, sized_box_for_whitespace, deprecated_member_use, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:friendly_card_mobie/components/custom_button.dart';
import 'package:friendly_card_mobie/components/custom_text_field.dart';
import 'package:friendly_card_mobie/controllers/main_controller.dart';
import 'package:friendly_card_mobie/controllers/study_history_controller.dart';
import 'package:friendly_card_mobie/controllers/topic_controller.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:friendly_card_mobie/controllers/vocabulary_controller.dart';
import 'package:friendly_card_mobie/models/topic.dart';
import 'package:friendly_card_mobie/utils/app_color.dart';
import 'package:friendly_card_mobie/widget/header.dart';
import 'package:friendly_card_mobie/widget/loading_page.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    return Obx(() {
      return mainController.loading.value
          ? LoadingPage()
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.03,
                  vertical: Get.height * 0.02,
                ),
                child: Column(
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: Get.width * 0.03,
                  //   vertical: Get.height * 0.02,
                  // ),
                  children: [
                    HeaderWidget(),
                    Expanded(
                      child: ListView(
                        children: [
                          MainFeaturesWidget(),
                          DailyGoalWidget(),
                          ContinueLearningWidget(),
                          SugguestTopicsWidget(),
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

// class HeaderHomeWidget extends StatelessWidget {
//   const HeaderHomeWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     UsersController usersController = Get.find<UsersController>();
//     return Obx(() {
//       return Container(
//         padding: EdgeInsets.only(
//           bottom: Get.height * 0.02,
//         ),
//         decoration: BoxDecoration(),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Hello, ${usersController.user.value.fullname}!',
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: AppColor.drakBlue, // Dark Blue
//                       ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Let's start the day with some vocabulary!",
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Colors.black54,
//                       ),
//                 ),
//               ],
//             ),
//             const CircleAvatar(
//               radius: 28,
//               backgroundImage: NetworkImage(
//                   'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png'), // Ảnh đại diện mẫu
//               backgroundColor: Colors.transparent,
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

class DailyGoalWidget extends StatelessWidget {
  const DailyGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();
    StudyHistoryController studyHistoryController =
        Get.find<StudyHistoryController>();
    return Obx(() {
      return usersController.user.value.daily_goal == 0
          ? Card(
              elevation: 4.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(Get.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Get.width * 0.5,
                      child: Text(
                        'Vui lòng đặt mục tiêu số từ vựng học mỗi ngày.',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.royalBlue,
                                ),
                      ),
                    ),
                    Container(
                        width: Get.width * 0.3,
                        child: CustomButton(
                          title: 'Đặt mục tiêu',
                          onClicked: () async {
                            await updateGoal(context);
                          },
                        ))
                  ],
                ),
              ),
            )
          : Card(
              elevation: 4.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(Get.width * 0.05),
                child: Row(
                  children: [
                    SizedBox(
                      height: Get.width * 0.2,
                      width: Get.width * 0.2,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: studyHistoryController.countStudyToday() /
                                usersController.user.value.daily_goal,
                            strokeWidth: 8.0,
                            backgroundColor: AppColor.skyBlue,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColor.royalBlue),
                          ),
                          Center(
                            child: Text(
                              '${studyHistoryController.countStudyToday()}/${usersController.user.value.daily_goal}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.drakBlue,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mục tiêu hôm nay',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.black54,
                                ),
                          ),
                          SizedBox(height: Get.height * 0.01),
                          Text(
                            studyHistoryController.listHistory.value.length <
                                    usersController.user.value.daily_goal
                                ? 'Bạn đã gần hoàn thành rồi, cố lên!'
                                : 'Chúc mừng bạn đã hoàn thành mục tiêu hàng ngày!',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.black54,
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

  Future<void> updateGoal(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    TextEditingController numController = TextEditingController(text: '10');
    await Get.dialog(
      AlertDialog(
        titlePadding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.025,
          vertical: Get.width * 0.01,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.025,
          // vertical: Get.width * 0.01,
        ),
        buttonPadding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.025,
          vertical: Get.width * 0.01,
        ),
        actionsPadding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.025,
          vertical: Get.width * 0.01,
        ),
        title: Column(
          children: [
            Text(
              'Mục tiêu',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.blue,
                  ),
            ),
            Divider(
              color: AppColor.blue,
            ),
          ],
        ),
        content: Container(
          child: Form(
            key: formKey,
            child: CustomTextField(
              controller: numController,
              label: 'Số từ vựng',
              required: true,
              type: ContactType.number,
            ),
          ),
        ),
        actions: [
          Column(
            children: [
              Divider(
                color: AppColor.blue,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                // width: Get.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Đóng'),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(AppColor.blue),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          Get.back();
                          Get.find<MainController>().loading.value = true;
                          await Get.find<UsersController>()
                              .updateGoal(int.parse(numController.value.text));
                          Get.find<MainController>().loading.value = false;
                        }
                      },
                      child: Text('Xác nhận'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MainFeaturesWidget extends StatelessWidget {
  const MainFeaturesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Get.height * 0.025,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // _buildFeatureItem(context, Icons.book_rounded, 'Chủ đề'),
          _buildFeatureItem(
              context, Icons.style_rounded, 'Học từ vựng', () async {}),
          _buildFeatureItem(
              context, Icons.gamepad_rounded, 'Luyện tập', () async {}),
          _buildFeatureItem(
              context, Icons.bar_chart_rounded, 'Thống kê', () async {}),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String label,
      Future<void> Function() onclick) {
    return Column(
      children: [
        InkWell(
          onTap: onclick,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.royalBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColor.royalBlue, size: 30),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.drakBlue,
              ),
        ),
      ],
    );
  }
}

class ContinueLearningWidget extends StatelessWidget {
  const ContinueLearningWidget({super.key});
  @override
  Widget build(BuildContext context) {
    TopicController topicController = Get.find<TopicController>();
    VocabularyController vocabularyController =
        Get.find<VocabularyController>();

    RxList<Topic> listContinute = <Topic>[].obs;

    return Obx(() {
      listContinute.value = topicController.listTopics.value
          .where((topic) => vocabularyController.listVocabulary
              .where((voca) => voca.is_studied && voca.topic_id == topic.id)
              .isNotEmpty)
          .toList();
      listContinute.value.sort((b, a) =>
          vocabularyController.listVocabulary.value
              .where((voca) => voca.topic_id == a.id && voca.is_studied)
              .length -
          vocabularyController.listVocabulary.value
              .where((voca) => voca.topic_id == b.id && voca.is_studied)
              .length);
      return listContinute.value.isEmpty
          ? SizedBox()
          : Container(
              margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tiếp tục học nào!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColor.drakBlue,
                        ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: Get.height * 0.2,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: listContinute.value
                          .map((item) => _buildCourseCard(context, item))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
    });
  }

  Widget _buildCourseCard(BuildContext context, Topic topic) {
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
        width: Get.width * 0.75,
        // height: Get.height * 0.25,
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
                width: Get.width * 0.75,
                fit: BoxFit.cover,
              ),
              // Lớp phủ màu đen mờ để chữ nổi bật
              Container(
                height: Get.height * 0.15,
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

class SugguestTopicsWidget extends StatelessWidget {
  const SugguestTopicsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TopicController topicController = Get.find<TopicController>();
    RxList<Topic> listSugguest = <Topic>[].obs;
    // RxList<Vocabulary> listVocabulary= <Vocabulary>[].obs;
    return Obx(() {
      listSugguest.value = topicController.getListTopicSugguest();
      return listSugguest.value.isEmpty
          ? SizedBox()
          : Container(
              margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chủ đề gợi ý cho bạn',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColor.drakBlue,
                        ),
                  ),
                  Column(
                    children: listSugguest.value
                        .map((item) => _buildTopicItem(context, item))
                        .toList(),
                  ),
                ],
              ),
            );
    });
  }

  Widget _buildTopicItem(BuildContext context, Topic topic) {
    return Card(
      elevation: 2.0,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: Get.height * 0.02),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.network(
            topic.image,
            height: Get.height * 0.25,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          // Lớp phủ màu đen mờ để chữ nổi bật
          Container(
            height: 120,
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
                  topic.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
