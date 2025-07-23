import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../services/firestore_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirestoreService>(() => FirestoreService(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
