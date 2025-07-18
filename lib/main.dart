// ignore_for_file: depend_on_referenced_packages, unused_import, await_only_futures

import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:friendly_card_mobile/controllers/study_history_controller.dart';
import 'package:friendly_card_mobile/controllers/topic_controller.dart';
import 'package:friendly_card_mobile/controllers/users_controller.dart';
import 'package:friendly_card_mobile/controllers/vocabulary_controller.dart';
import 'package:friendly_card_mobile/models/study_history.dart';
import 'package:friendly_card_mobile/models/topic.dart';
import 'package:friendly_card_mobile/models/vocabulary.dart';
import 'package:friendly_card_mobile/utils/inital_binding.dart';
import 'package:friendly_card_mobile/views/home_page.dart';
import 'package:friendly_card_mobile/views/login_page.dart';
import 'package:friendly_card_mobile/views/screens/all_vocabulary_screen.dart';
import 'package:friendly_card_mobile/views/screens/vocabulary_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBC5fiyM2jV6IhRnzpcIBIznSUPUUb6dsA",
      authDomain: "friendly-card.firebaseapp.com",
      projectId: "friendly-card",
      storageBucket: "friendly-card.firebasestorage.app",
      messagingSenderId: "496923338414",
      appId: "1:496923338414:android:24a2e32d73a714a401af3f",
    ),
  );

  Get.config(enableLog: false, defaultTransition: Transition.native);

  await GetStorage.init();

  runApp(const MyApp());

  await Timer.periodic(Duration(seconds: 30), (timer) async {
    log('30s load 1 lan');
    TopicController topicController = Get.find<TopicController>();
    VocabularyController vocabularyController =
        Get.find<VocabularyController>();
    StudyHistoryController studyHistoryController =
        Get.find<StudyHistoryController>();
    UsersController usersController = Get.find<UsersController>();

    List<Topic> listTopic = [];
    List<Vocabulary> listVocabulary = [];
    List<StudyHistory> listHistory = [];

    if (usersController.user.value.id != '') {
      var snapshortTopic = await topicController.topicCollection
          .where('status', isEqualTo: 'active')
          .get();
      for (var topicItem in snapshortTopic.docs) {
        var snapshortVoca = await vocabularyController.vocabularyCollection
            .where('topic_id', isEqualTo: topicItem.id)
            .where('status', isEqualTo: 'active')
            .get();

        if (snapshortVoca.docs.isNotEmpty) {
          for (var vocaItem in snapshortVoca.docs) {
            var snapshortHistory = await studyHistoryController
                .studyHistoryCollection
                .where('vocabulary_id', isEqualTo: vocaItem.id)
                .where('user_id', isEqualTo: usersController.user.value.id)
                .get();
            for (var item in snapshortHistory.docs) {
              Map<String, dynamic> data = item.data() as Map<String, dynamic>;
              data['id'] = item.id;
              listHistory.add((StudyHistory.fromJson(data)));
            }

            Map<String, dynamic> vocaData =
                vocaItem.data() as Map<String, dynamic>;
            vocaData['id'] = vocaItem.id;
            vocaData['is_studied'] = snapshortHistory.docs.isNotEmpty;

            listVocabulary.add(Vocabulary.fromJson(vocaData));
          }
          Map<String, dynamic> topicData =
              topicItem.data() as Map<String, dynamic>;
          topicData['id'] = topicItem.id;
          listTopic.add(Topic.fromJson(topicData));
        }
      }

      topicController.listTopics.value = listTopic;
      vocabularyController.listVocabulary.value = listVocabulary;
      studyHistoryController.listHistory.value = listHistory;
    }
    log('done');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [Locale('vi'), Locale('en'), Locale('fr')],
      locale: const Locale('vi'),
      initialRoute: "/login",
      initialBinding: InitalBinding(),
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
        ),
        GetPage(
          name: '/',
          page: () => const HomePage(),
        ),
        GetPage(
          name: '/all_vocabulary',
          page: () => const AllVocabularyScreen(),
        ),
        GetPage(
          name: '/vocabulary',
          page: () => const VocabularyScreen(),
        ),
      ],
    );
  }
}
