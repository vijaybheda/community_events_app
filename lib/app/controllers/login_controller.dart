import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class LoginController extends GetxController {
  final error = ''.obs;

  Future<void> signInWithGoogle() async {
    error.value = '';
    try {
      await Get.find<AuthService>().signInWithGoogle();
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      error.value = 'Sign in failed. Please try again.';
    }
  }
}
