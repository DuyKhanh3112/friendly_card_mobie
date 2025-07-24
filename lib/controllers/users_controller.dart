import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_mobile/controllers/cloudinary_controller.dart';
import 'package:friendly_card_mobile/controllers/main_controller.dart';
import 'package:friendly_card_mobile/models/users.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UsersController extends GetxController {
  RxBool loading = false.obs;
  RxString role = ''.obs;
  Rx<Users> user = Users.initUser().obs;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveSession(String userId) async {
    final box = GetStorage();
    box.write('user_id', userId);
  }

  Future<String?> getSession() async {
    final box = GetStorage();
    return box.read('user_id');
  }

  Future<void> clearSession() async {
    final box = GetStorage();
    box.remove('user_id');
  }

  Future<bool> login(String uname, String pword) async {
    loading.value = true;
    user.value = Users.initUser();

    final snapshot = await usersCollection
        .where('username', isEqualTo: uname)
        .where('password', isEqualTo: pword)
        .where('role', whereIn: ['learner'])
        .where('active', isEqualTo: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          snapshot.docs[0].data() as Map<String, dynamic>;
      data['id'] = snapshot.docs[0].id;
      user.value = Users.fromJson(data);
      role.value = user.value.role;
      await saveSession(user.value.id);
      await Get.find<MainController>().loadData();
      loading.value = false;
      Get.toNamed('/');
      return true;
    }
    loading.value = false;
    return false;
  }

  Future<void> loginSession() async {
    loading.value = true;
    user.value = Users.initUser();
    var userId = await getSession();
    final snapshot = await usersCollection.doc(userId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data['id'] = snapshot.id;
      user.value = Users.fromJson(data);
      role.value = user.value.role;
      await saveSession(user.value.id);
      await Get.find<MainController>().loadData();
      loading.value = false;
      Get.toNamed('/');
    }
    loading.value = false;
  }

  Future<void> logout() async {
    loading.value = true;
    user.value = Users.initUser();
    role.value = '';
    await clearSession();
    Get.toNamed('/login');
    loading.value = false;
  }

  Future<void> updateInformationUser() async {
    loading.value = true;
    user.value.update_at = Timestamp.now();
    await usersCollection.doc(user.value.id).update(user.value.toVal());
    loading.value = false;
  }

  Future<void> updateGoal(int goal) async {
    loading.value = true;
    user.value.update_at = Timestamp.now();
    user.value.daily_goal = goal;
    await usersCollection.doc(user.value.id).update(user.value.toVal());
    loading.value = false;
  }

  Future<bool> checkExistEmail(String email) async {
    loading.value = true;
    var snapshot = await usersCollection
        .where('email', isEqualTo: email)
        .where('role', isEqualTo: 'learner')
        .where('active', isEqualTo: true)
        .get();
    loading.value = false;
    return snapshot.docs.isNotEmpty;
  }

  Future<bool> checkExistUsername(String uname) async {
    loading.value = true;
    var snapshot = await usersCollection
        .where('username', isEqualTo: uname)
        .where('role', isEqualTo: 'learner')
        .where('active', isEqualTo: true)
        .get();
    loading.value = false;
    return snapshot.docs.isNotEmpty;
  }

  Future<void> registerLearner(Users learner, String filePath) async {
    loading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String id = usersCollection.doc().id;
    DocumentReference refTeacher = usersCollection.doc(id);
    learner.update_at = Timestamp.now();
    learner.role = 'teacher';

    if (filePath == '') {
      learner.avatar = await CloudinaryController().uploadImageFile(
          filePath, learner.username, 'learner/${learner.username}');
    }
    batch.set(refTeacher, learner.toVal());
    await batch.commit();
    loading.value = false;
  }
}
