import 'package:get/get.dart';
import 'package:panoramicai/features/deteksi/presentations/controllers/deteksi_controller.dart';

class DeteksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeteksiController());
  }
}
