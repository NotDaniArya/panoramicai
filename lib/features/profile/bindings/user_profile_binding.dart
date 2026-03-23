import 'package:get/get.dart';
import 'package:panoramicai/features/profile/presentations/controllers/profile_controller.dart';

class UserProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfileController());
  }
}
