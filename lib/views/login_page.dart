// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:friendly_card_mobile/components/custom_button.dart';
import 'package:friendly_card_mobile/components/custom_dialog.dart';
import 'package:friendly_card_mobile/components/custom_text_field.dart';
import 'package:friendly_card_mobile/controllers/users_controller.dart';
import 'package:friendly_card_mobile/utils/app_color.dart';
import 'package:friendly_card_mobile/widget/loading_page.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();
    final formKey = GlobalKey<FormState>();

    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Obx(() {
      return usersController.loading.value
          ? LoadingPage()
          : Scaffold(
              backgroundColor: AppColor.lightBlue,
              body: SafeArea(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05,
                      vertical: Get.width * 0.1,
                    ),
                    constraints: BoxConstraints(
                      minHeight: Get.height * 0.5,
                      maxHeight: Get.height * 0.8,
                    ),
                    child: Form(
                      key: formKey,
                      child: ListView(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Image.network(
                                'https://res.cloudinary.com/drir6xyuq/image/upload/v1752483066/logo-removebg.png',
                                width: Get.width * 0.9,
                              ),
                            ],
                          ),
                          const SizedBox(height: 48),
                          CustomTextField(
                            label: 'Tên đăng nhập',
                            controller: usernameController,
                            required: true,
                            prefix: Icon(
                              Icons.person_outline_rounded,
                              color: AppColor.labelBlue,
                            ),
                          ),
                          CustomTextField(
                            label: 'Mật khẩu',
                            controller: passwordController,
                            required: true,
                            isPassword: true,
                            prefix: Icon(
                              Icons.lock_outline_rounded,
                              color: AppColor.labelBlue,
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                  color: AppColor.blue,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),

                          // --- Nút Đăng nhập ---
                          CustomButton(
                            title: 'Đăng nhập',
                            onClicked: () async {
                              if (formKey.currentState!.validate()) {
                                bool res = await usersController.login(
                                  usernameController.value.text,
                                  passwordController.value.text,
                                );
                                if (!res) {
                                  if (usersController.user.value.id == '') {
                                    await showAlertDialog(
                                      context,
                                      DialogType.error,
                                      'Đăng nhập không thành công!',
                                      'Tài khoản hoặc mật khẩu không đúng.',
                                    );
                                    return;
                                  }
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: Get.height * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Chưa có tài khoản? ',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  'Đăng ký ngay',
                                  style: TextStyle(
                                    color: AppColor.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
