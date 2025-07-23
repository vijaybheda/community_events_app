import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class HomeController extends GetxController {
  final events = <Event>[].obs;
  final eventTitles = <String>[];
  final isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadEvents();
    _checkAuthenticationStatus();
  }

  void _loadEvents() {
    FirestoreService().getEvents().listen((eventList) {
      events.value = eventList;
      eventTitles.clear();
      eventTitles.addAll(eventList.map((e) => e.title));
    });
  }

  void _checkAuthenticationStatus() {
    final authService = Get.find<AuthService>();
    isAuthenticated.value = authService.currentUser.value != null;
    
    // Listen to auth state changes
    ever(authService.currentUser, (user) {
      isAuthenticated.value = user != null;
    });
  }

  List<String> searchEvents(String query, List<String> list) {
    return list.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void onEventSelected(String title) {
    final event = events.firstWhereOrNull((e) => e.title == title);
    if (event != null) {
      goToEventDetails(event);
    }
  }

  Future<void> refreshEvents() async {
    _loadEvents();
  }

  String getRsvpStatus(Event event) {
    if (!isAuthenticated.value) return 'Login to RSVP';
    
    final currentUser = Get.find<AuthService>().currentUser.value;
    if (currentUser != null && event.attendees.contains(currentUser.uid)) {
      return 'Attending';
    }
    return 'Not Attending';
  }

  Color getRsvpColor(Event event) {
    if (!isAuthenticated.value) return Get.theme.disabledColor;
    
    final status = getRsvpStatus(event);
    switch (status) {
      case 'Attending':
        return Colors.green;
      case 'Not Attending':
        return Colors.red;
      default:
        return Get.theme.disabledColor;
    }
  }

  void goToEventDetails(Event event) {
    Get.toNamed(AppRoutes.eventDetails, arguments: event);
  }

  void goToAddEvent() {
    if (!isAuthenticated.value) {
      _showLoginRequiredDialog('Create Events');
      return;
    }
    Get.toNamed(AppRoutes.addEvent);
  }

  void goToProfile() {
    if (!isAuthenticated.value) {
      _showLoginRequiredDialog('Access Profile');
      return;
    }
    Get.toNamed(AppRoutes.profile);
  }

  void goToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  void _showLoginRequiredDialog(String action) {
    Get.dialog(
      AlertDialog(
        title: const Text('Login Required'),
        content: Text('Please login to $action.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              goToLogin();
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
