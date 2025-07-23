import 'package:get/get.dart';
import '../controllers/my_rsvps_controller.dart';

class MyRsvpsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyRsvpsController>(() => MyRsvpsController());
  }
} 