// ignore_for_file: deprecated_member_use, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:friendly_card_mobie/controllers/main_controller.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    return Obx(() {
      return Scaffold(
        // appBar: AppBar(
        //   title: HeaderWidget(),
        // ),
        body: SafeArea(
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            children: const [
              HeaderHomeWidget(),
              SizedBox(height: 24),
              MainFeaturesWidget(),
              SizedBox(height: 30),
              ContinueLearningWidget(),
              SizedBox(height: 30),
              DiscoverTopicsWidget(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_rounded),
              label: 'Chủ đề',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.gamepad_rounded),
              label: 'Luyện tập',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Cá nhân',
            ),
          ],
          currentIndex: mainController.currentPage.value,
          selectedItemColor: const Color(0xFF4169E1), // Royal Blue
          unselectedItemColor: Colors.grey,
          onTap: (value) {
            mainController.currentPage.value = value;
          },
          type: BottomNavigationBarType.fixed, // Giữ vị trí cố định
          backgroundColor: Colors.white,
          elevation: 8.0,
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
    return Card(
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
              height: 70,
              width: 70,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 8 / 15, // 8 trên 15 từ
                    strokeWidth: 8.0,
                    backgroundColor: const Color(0xFF87CEEB)
                        .withOpacity(0.3), // Sky Blue nhạt
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4169E1)), // Royal Blue
                  ),
                  Center(
                    child: Text(
                      '8/15',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00008B),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bạn đã gần hoàn thành rồi, cố lên!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
  }
}

class MainFeaturesWidget extends StatelessWidget {
  const MainFeaturesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFeatureItem(context, Icons.book_rounded, 'Chủ đề'),
        _buildFeatureItem(context, Icons.style_rounded, 'Ôn tập'),
        _buildFeatureItem(context, Icons.gamepad_rounded, 'Luyện tập'),
        _buildFeatureItem(context, Icons.star_rounded, 'Từ của bạn'),
      ],
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
    return Column(
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
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCourseCard(
                  context, 'Từ vựng về Du lịch', 30, 50, Colors.orange),
              const SizedBox(width: 16),
              _buildCourseCard(
                  context, 'Từ vựng IELTS Band 8.0', 120, 500, Colors.teal),
              const SizedBox(width: 16),
              _buildCourseCard(
                  context, 'Giao tiếp công sở', 45, 60, Colors.indigo),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(BuildContext context, String title, int completed,
      int total, Color color) {
    return Container(
      width: 220,
      child: Card(
        elevation: 2.0,
        color: color.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'total từ',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: completed / total,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiscoverTopicsWidget extends StatelessWidget {
  const DiscoverTopicsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chủ đề gợi ý cho bạn',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00008B),
              ),
        ),
        const SizedBox(height: 16),
        _buildTopicItem(
          context,
          'Công nghệ',
          'Khám phá thế giới của AI, lập trình và đổi mới.',
          'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png',
        ),
        const SizedBox(height: 12),
        _buildTopicItem(
          context,
          'Ẩm thực',
          'Học từ vựng để trở thành một chuyên gia ẩm thực.',
          'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png',
        ),
      ],
    );
  }

  Widget _buildTopicItem(
      BuildContext context, String title, String subtitle, String imageUrl) {
    return Card(
      elevation: 2.0,
      clipBehavior: Clip.antiAlias, // Để bo góc hình ảnh
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.network(
            imageUrl,
            height: 120,
            width: double.infinity,
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
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
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
