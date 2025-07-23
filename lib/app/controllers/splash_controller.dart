import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    print('onReady');
    Future.delayed(const Duration(seconds: 2), _navigate);
  }

  void _navigate() {
    final authService = Get.find<AuthService>();
    print('_navigate ${authService.currentUser.value}');
    // Allow guest mode - navigate to Home for all users
    // Authenticated users will see full features, guests will see limited features
    Get.offAllNamed(AppRoutes.home);
  }
}
