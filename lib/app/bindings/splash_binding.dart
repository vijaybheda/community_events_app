import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../services/auth_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    print('SplashBinding');
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<SplashController>(() => SplashController());
    print('SplashBinding done 1');
    Get.put(SplashController());
    print('SplashBinding done 2');
    Get.put(AuthService());
    print('SplashBinding done 3');
    print('SplashBinding done');
  }
}
