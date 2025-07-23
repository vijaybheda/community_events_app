import 'package:get/get.dart';
import 'app_routes.dart';
import '../views/splash_view.dart';
import '../views/login_view.dart';
import '../views/home_view.dart';
import '../views/event_details_view.dart';
import '../views/add_event_view.dart';
import '../views/profile_view.dart';
import '../views/my_rsvps_view.dart';
import '../views/about_view.dart';
import '../bindings/splash_binding.dart';
import '../bindings/login_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/event_details_binding.dart';
import '../bindings/add_event_binding.dart';
import '../bindings/profile_binding.dart';
import '../bindings/my_rsvps_binding.dart';
import '../bindings/about_binding.dart';

class AppPages {
  static const INITIAL = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.eventDetails,
      page: () => const EventDetailsView(),
      binding: EventDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.addEvent,
      page: () => const AddEventView(),
      binding: AddEventBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.myRsvps,
      page: () => const MyRsvpsView(),
      binding: MyRsvpsBinding(),
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
  ];
}
