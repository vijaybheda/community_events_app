import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class MyRsvpsController extends GetxController {
  final rsvpEvents = <Event>[].obs;
  final isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthenticationStatus();
    _loadRsvpEvents();
  }

  void _checkAuthenticationStatus() {
    final authService = Get.find<AuthService>();
    isAuthenticated.value = authService.currentUser.value != null;

    // Listen to auth state changes
    ever(authService.currentUser, (user) {
      isAuthenticated.value = user != null;
      if (user != null) {
        _loadRsvpEvents();
      }
    });
  }

  void _loadRsvpEvents() {
    if (!isAuthenticated.value) return;

    final currentUser = Get.find<AuthService>().currentUser.value;
    if (currentUser == null) return;

    FirestoreService().getEvents().listen((eventList) {
      rsvpEvents.value = eventList
          .where((event) => event.attendees.contains(currentUser.uid))
          .toList();
    });
  }

  String getRsvpStatus(Event event) {
    final currentUser = Get.find<AuthService>().currentUser.value;
    if (currentUser == null) return 'Unknown';

    if (event.attendees.contains(currentUser.uid)) {
      return 'Attending';
    }
    return 'Not Attending';
  }

  Color getRsvpColor(Event event) {
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

  Future<void> revokeRsvp(Event event) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Revoke RSVP'),
        content: Text(
          'Are you sure you want to revoke your RSVP for "${event.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Revoke'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final currentUser = Get.find<AuthService>().currentUser.value;
        if (currentUser == null) return;

        final updatedEvent = Event(
          id: event.id,
          title: event.title,
          description: event.description,
          dateTime: event.dateTime,
          location: event.location,
          imageUrl: event.imageUrl,
          createdBy: event.createdBy,
          attendees: event.attendees
              .where((id) => id != currentUser.uid)
              .toList(),
          category: event.category,
          createdOn: event.createdOn,
          updatedOn: DateTime.now(),
        );

        await Get.find<FirestoreService>().updateEvent(updatedEvent);

        Get.snackbar(
          'Success',
          'RSVP revoked successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to revoke RSVP. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
