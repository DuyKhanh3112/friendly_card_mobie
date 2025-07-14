import 'package:friendly_card_mobie/controllers/main_controller.dart';
import 'package:friendly_card_mobie/controllers/users_controller.dart';
import 'package:get/get.dart';

class InitalBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(MainController());
    Get.put(UsersController());
  }
}

// class AdminBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.find<UsersController>().checkLogin();
//   }
// }
