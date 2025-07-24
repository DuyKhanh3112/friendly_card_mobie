import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:friendly_card_mobile/controllers/study_history_controller.dart';
import 'package:friendly_card_mobile/controllers/topic_controller.dart';
import 'package:friendly_card_mobile/models/users.dart';
import 'package:friendly_card_mobile/views/screens/home_screen.dart';
import 'package:friendly_card_mobile/views/screens/topic_screen.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class MainController extends GetxController {
  RxInt currentPage = 0.obs;
  RxBool loading = false.obs;

  List<Widget> pages = [
    HomeScreen(),
    TopicScreen(),
    TopicScreen(),
    HomeScreen(),
  ];

  Future<void> loadData() async {
    loading.value = true;
    Get.find<StudyHistoryController>().listHistory.value = [];
    await Get.find<TopicController>().loadTopic();
    // print(Get.find<StudyHistoryController>().listHistory.value.length);
    loading.value = false;
  }

  RxString otpCode = ''.obs;

  Future<void> sendOtp(Users user) async {
    // isLoading.value = true;
    otpCode.value = (100000 + Random().nextInt(899999)).toString();

    String htmlTxt = '''
        <div align="center" style="color:#5BC0DE;">
              <div style="width:600px; border:1px solid #dadce0; background-color:#f8fbff;
                      border-radius:8px; padding:40px 20px; text-align:left;">
                      <div align="center">
                            <img src="https://res.cloudinary.com/drir6xyuq/image/upload/v1752483066/logo-removebg.png"
                                    height="100" style="margin-bottom:16px;" alt="Friendly Card Logo">
                      </div>
                      <div style="border-bottom:1px solid #dadce0; padding-bottom:24px; text-align:center;">
                            <span style="font-size:24px; color:#5BC0DE;">
                                    Xin chào
                                    <strong style="font-size:24px; font-weight:600; color:#5BC0DE;">
                                          ${user.username}
                                    </strong>!
                            </span>
                      </div>
                      <div style="margin-top:24px;">
                            <div style="font-size:20px; color:#5BC0DE;">
                                    Bạn vừa thực hiện chức năng <strong>quên mật khẩu</strong> của ứng dụng
                                    <strong style="font-size:20px; color:#5BC0DE;">Friendly Card</strong>.
                                    Vui lòng lấy mã OTP để tạo mật khẩu mới.
                            </div>
                            <div style="font-size:20px; color:#5BC0DE;margin-top:8px;">
                                    Mã OTP của bạn là:
                                    <strong style="font-size:24px; font-weight:600; color:#00008B;">
                                          ${otpCode.value}
                                    </strong>
                            </div>
                            <div style="font-size:16px; color:red; font-style:italic;margin-top:8px;">
                                    Xin vui lòng không cung cấp OTP cho bất kỳ ai !!!
                            </div>
                      </div>
              </div>
        </div>''';
    await sendMail(user.email ?? '', '[MÃ OTP] Quên mật khẩu', htmlTxt);
  }

  Future<void> sendMailWelcome(Users users) async {
    final String emailHtml = '''
                <div align='center' style='color:#5BC0DE;'>
                  <div style='width:600px;border-style:solid;border-width:thin;border-color:#dadce0;background-color:#f8fbff;
                              border-radius:8px;padding:40px 20px' align='center'>
                    <img src='https://res.cloudinary.com/drir6xyuq/image/upload/v1752483066/logo-removebg.png' height='100'
                        aria-hidden='true' style='margin-bottom:16px' alt='Google'>
                    <div style='border-bottom:thin solid #dadce0;color:rgba(0,0,0,0.87);line-height:32px;
                                padding-bottom:24px;text-align:center;word-break:break-word'>
                      <div style='display:flex;align-items:center;justify-content:center;'>
                        <span style='font-size:24px;color:#5BC0DE'>
                          Chào mừng bạn đến với 
                          <span style='font-size:32px;font-weight:600;color:#5BC0DE'>
                            Friendly Card
                          </span>
                        </span>
                      </div>
                    </div>
                    <div style='display:flex;align-items:center;justify-content:center;'>
                      <span style='font-size:24px;color:#5BC0DE'>
                        Chúc mừng bạn đăng ký tài khoản thành công!
                      </span>
                    </div>
                    <div style='align-items: center; justify-content: center;'>
                      <span style='font-size:24px;color:#5BC0DE'>Tên đăng nhập của bạn là: <strong>${users.username}</strong></span>
                    </div>
                  </div>
                </div>
                ''';

    await sendMail(users.email ?? 'vdkhanh3112@gmail.com',
        'CHÀO MỪNG BẠN ĐẾN VỀ FRIENDLY CARD', emailHtml);
  }

  Future<void> sendMail(String mailUser, String subject, String html) async {
    // Thông tin đăng nhập và cấu hình SMTP (ví dụ sử dụng Gmail SMTP)
    const String username = 'friendlycard2025@gmail.com';
    const String password = 'qstj qtzq docl ebrn';

    // Cấu hình SMTP cho Gmail (hoặc thay đổi cho các nhà cung cấp khác)
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = const Address(username, 'Friendly Card')
      ..recipients.add(mailUser)
      ..subject = subject
      // ..text = text
      ..html = html;

    try {
      // Gửi email
      await send(message, smtpServer);
    } on MailerException catch (e) {
      for (var p in e.problems) {
        // ignore: avoid_print
        print('Lỗi: ${p.code}: ${p.msg}');
      }
    }
  }
}
