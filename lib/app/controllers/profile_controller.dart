import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class ProfileController extends GetxController {
  final currentUser = Rxn<AppUser>();
  final currentLanguage = 'English'.obs;
  final currentTheme = 'System'.obs;
  final isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthenticationStatus();
    _loadUserProfile();
  }

  void _checkAuthenticationStatus() {
    final authService = Get.find<AuthService>();
    isAuthenticated.value = authService.currentUser.value != null;

    // Listen to auth state changes
    ever(authService.currentUser, (user) {
      isAuthenticated.value = user != null;
    });
  }

  void _loadUserProfile() {
    final authService = Get.find<AuthService>();
    currentUser.value = authService.currentUser.value;

    // Listen to auth state changes
    ever(authService.currentUser, (user) {
      currentUser.value = user;
    });
  }

  void editProfile() {
    // TODO: Implement edit profile functionality
    Get.snackbar(
      'Edit Profile',
      'Profile editing feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goToMyEvents() {
    // TODO: Navigate to user's created events
    Get.snackbar(
      'My Events',
      'My events feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goToMyRsvps() {
    Get.toNamed(AppRoutes.myRsvps);
  }

  void changeLanguage() {
    Get.bottomSheet(
      Container(
        color: Get.theme.scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                Get.updateLocale(const Locale('en', 'US'));
                currentLanguage.value = 'English';
                Get.back();
              },
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                Get.updateLocale(const Locale('ar', 'SA'));
                currentLanguage.value = 'العربية';
                Get.back();
              },
            ),
            ListTile(
              title: const Text('हिंदी'),
              onTap: () {
                Get.updateLocale(const Locale('hi', 'IN'));
                currentLanguage.value = 'हिंदी';
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void changeTheme() {
    Get.bottomSheet(
      Container(
        color: Get.theme.scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System'),
              onTap: () {
                Get.changeThemeMode(ThemeMode.system);
                currentTheme.value = 'System';
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Light'),
              onTap: () {
                Get.changeThemeMode(ThemeMode.light);
                currentTheme.value = 'Light';
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Dark'),
              onTap: () {
                Get.changeThemeMode(ThemeMode.dark);
                currentTheme.value = 'Dark';
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void goToAbout() {
    Get.toNamed(AppRoutes.about);
  }

  void goToSettings() {
    // TODO: Implement settings screen
    Get.snackbar(
      'Settings',
      'Settings feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Get.find<AuthService>().signOut();
        Get.offAllNamed(AppRoutes.home);
        Get.snackbar(
          'Success',
          'Logged out successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to logout. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
