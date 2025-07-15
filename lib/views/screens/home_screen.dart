// ignore_for_file: invalid_use_of_protected_member, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:friendly_card_mobie/controllers/main_controller.dart';
import 'package:friendly_card_mobie/controllers/study_history_controller.dart';
import 'package:friendly_card_mobie/controllers/topic_controller.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:friendly_card_mobie/controllers/vocabulary_controller.dart';
import 'package:friendly_card_mobie/models/study_history.dart';
import 'package:friendly_card_mobie/models/topic.dart';
import 'package:friendly_card_mobie/models/vocabulary.dart';
import 'package:friendly_card_mobie/widget/loading_page.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    StudyHistoryController studyHistoryController =
        Get.find<StudyHistoryController>();
    return Obx(() {
      return mainController.loading.value ||
              studyHistoryController.loading.value
          ? LoadingPage()
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                children: const [
                  HeaderHomeWidget(),
                  // SizedBox(height: 24),
                  MainFeaturesWidget(),
                  // SizedBox(height: 30),
                  DailyGoalWidget(),
                  // SizedBox(height: 30),
                  ContinueLearningWidget(),
                  // SizedBox(height: 30),
                  SugguestTopicsWidget(),
                ],
              ),
            );
    });
  }
}

class HeaderHomeWidget extends StatelessWidget {
  const HeaderHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${usersController.user.value.fullname}!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00008B), // Dark Blue
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                "Let's start the day with some vocabulary!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
                'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png'), // Ảnh đại diện mẫu
            backgroundColor: Colors.transparent,
          ),
        ],
      );
    });
  }
}

class DailyGoalWidget extends StatelessWidget {
  const DailyGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();
    StudyHistoryController studyHistoryController =
        Get.find<StudyHistoryController>();
    return Obx(() {
      return usersController.user.value.daily_goal == 0
          ? SizedBox()
          : Card(
              elevation: 4.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                            backgroundColor: const Color(0xFF87CEEB)
                                .withOpacity(0.3), // Sky Blue nhạt
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF4169E1)), // Royal Blue
                          ),
                          Center(
                            child: Text(
                              '${studyHistoryController.countStudyToday()}/${usersController.user.value.daily_goal}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF00008B),
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
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00008B),
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
          _buildFeatureItem(context, Icons.book_rounded, 'Chủ đề'),
          _buildFeatureItem(context, Icons.style_rounded, 'Ôn tập'),
          _buildFeatureItem(context, Icons.gamepad_rounded, 'Luyện tập'),
          _buildFeatureItem(context, Icons.star_rounded, 'Từ của bạn'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4169E1).withOpacity(0.1), // Royal Blue nhạt
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon,
              color: const Color(0xFF4169E1), size: 30), // Royal Blue
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF00008B),
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
                          color: const Color(0xFF00008B),
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
                      topic.name,
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
                          color: const Color(0xFF00008B),
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
