// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:friendly_card_mobile/components/custom_button.dart';
import 'package:friendly_card_mobile/components/custom_dialog.dart';
import 'package:friendly_card_mobile/components/custom_text_field.dart';
import 'package:friendly_card_mobile/controllers/users_controller.dart';
import 'package:friendly_card_mobile/models/users.dart';
import 'package:friendly_card_mobile/utils/app_color.dart';
import 'package:friendly_card_mobile/widget/loading_page.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();
    final formKey = GlobalKey<FormState>();

    final fullnameController = TextEditingController();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final passwordConfController = TextEditingController();

    Rx<String> filePath = ''.obs;

    return Obx(() {
      return usersController.loading.value
          ? LoadingPage()
          : Scaffold(
              appBar: AppBar(
                backgroundColor: AppColor.lightBlue,
                foregroundColor: AppColor.royalBlue,
                title: Text(
                  'Đăng ký tài khoản',
                  style: TextStyle(
                    color: AppColor.royalBlue,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              backgroundColor: AppColor.lightBlue,
              body: SafeArea(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05,
                      vertical: Get.height * 0.01,
                    ),
                    constraints: BoxConstraints(
                      minHeight: Get.height * 0.5,
                      // maxHeight: Get.height * 0.8,
                    ),
                    child: Form(
                      key: formKey,
                      child: ListView(
                        children: [
                          // Image.network(
                          //   'https://res.cloudinary.com/drir6xyuq/image/upload/v1752483066/logo-removebg.png',
                          //   width: Get.width * 0.9,
                          // ),

                          CustomTextField(
                            label: 'Tên đăng nhập',
                            controller: usernameController,
                            minLength: 6,
                            required: true,
                            prefix: Icon(
                              Icons.person_outline_rounded,
                              color: AppColor.labelBlue,
                            ),
                          ),
                          CustomTextField(
                            label: 'Họ tên',
                            controller: fullnameController,
                            required: true,
                            prefix: Icon(
                              Icons.local_library_outlined,
                              color: AppColor.labelBlue,
                            ),
                          ),
                          CustomTextField(
                            label: 'Số điện thoại',
                            controller: phoneController,
                            type: ContactType.phone,
                            required: false,
                            prefix: Icon(
                              Icons.phone_enabled_outlined,
                              color: AppColor.labelBlue,
                            ),
                          ),
                          CustomTextField(
                            label: 'Email',
                            controller: emailController,
                            type: ContactType.mail,
                            required: true,
                            prefix: Icon(
                              Icons.mail_outline_rounded,
                              color: AppColor.labelBlue,
                            ),
                          ),
                          CustomTextField(
                            label: 'Mật khẩu',
                            controller: passwordController,
                            minLength: 6,
                            required: true,
                            isPassword: true,
                            prefix: Icon(
                              Icons.lock_outline_rounded,
                              color: AppColor.labelBlue,
                            ),
                          ),
                          CustomTextField(
                            label: 'Xác nhận mật khẩu',
                            controller: passwordConfController,
                            required: true,
                            isPassword: true,
                            prefix: Icon(
                              Icons.lock_outline_rounded,
                              color: AppColor.labelBlue,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: Get.width * 0.025,
                            ),
                            // width: Get.width * 0.3,
                            margin: EdgeInsets.symmetric(
                              vertical: Get.width * 0.025,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            child: InkWell(
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                      left: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.image),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          'Ảnh đại diện',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColor.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.3,
                                    height: Get.width * 0.3,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColor.lightBlue,
                                      ),
                                      image: filePath.value == ''
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png',
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : DecorationImage(
                                              image: FileImage(
                                                File(filePath.value),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Text(
                                    '(Nhấp vào ảnh để thay đổi ảnh đại diện)',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: AppColor.blue,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.photo_library),
                                          title: Text('Chọn từ thư viện'),
                                          onTap: () async {
                                            Get.back();
                                            final pickedFile =
                                                await ImagePicker().pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (pickedFile != null) {
                                              filePath.value = pickedFile.path;
                                            }
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.camera_alt),
                                          title: Text('Chụp ảnh'),
                                          onTap: () async {
                                            Get.back();
                                            final pickedFile =
                                                await ImagePicker().pickImage(
                                                    source: ImageSource.camera);
                                            if (pickedFile != null) {
                                              filePath.value = pickedFile.path;
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          CustomButton(
                            title: 'Đăng ký',
                            onClicked: () async {
                              if (formKey.currentState!.validate()) {
                                if (passwordController.text !=
                                    passwordConfController.text) {
                                  await showAlertDialog(
                                    context,
                                    DialogType.error,
                                    'Đăng ký không thành công!',
                                    'Mật khẩu không trùng khớp. Vui lòng xác nhận lại mật khẩu',
                                  );
                                  return;
                                }

                                if (await usersController.checkExistUsername(
                                    usernameController.text)) {
                                  await showAlertDialog(
                                    context,
                                    DialogType.error,
                                    'Đăng ký không thành công!',
                                    'tên đăng nhập: `${usernameController.text}` đã được đăng ký tài khoản. Vui lòng nhập email khác!',
                                  );
                                  return;
                                }

                                if (await usersController
                                    .checkExistEmail(emailController.text)) {
                                  await showAlertDialog(
                                    context,
                                    DialogType.error,
                                    'Đăng ký không thành công!',
                                    'Email: `${emailController.text}` đã được đăng ký tài khoản. Vui lòng nhập email khác!',
                                  );
                                  return;
                                }
                                Users learner = Users.initUser();
                                learner.fullname = fullnameController.text;
                                learner.username = usernameController.text;
                                learner.email = emailController.text;
                                learner.phone = phoneController.text;
                                learner.password = passwordController.text;
                                await usersController.registerLearner(
                                    learner, filePath.value);

                                await showAlertDialog(
                                  context,
                                  DialogType.success,
                                  'Đăng ký tài khoản thành công',
                                  '',
                                );
                                Get.back();
                              }
                            },
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
