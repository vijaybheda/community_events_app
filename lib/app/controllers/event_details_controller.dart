import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event.dart';
import '../models/app_user.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class EventDetailsController extends GetxController {
  final event = Rxn<Event>();
  final attendees = <AppUser>[].obs;
  final isAttending = false.obs;
  final isNotAttending = false.obs;
  final isCreator = false.obs;
  final isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    final eventArg = Get.arguments as Event;
    event.value = eventArg;
    _loadEventDetails();
    _checkAuthenticationStatus();
    _checkRsvpStatus();
    _checkCreatorStatus();
  }

  void _loadEventDetails() {
    // TODO: Load attendees details from Firestore
    // For now, using dummy data
    attendees.value = [];
  }

  void _checkAuthenticationStatus() {
    final authService = Get.find<AuthService>();
    isAuthenticated.value = authService.currentUser.value != null;
    
    // Listen to auth state changes
    ever(authService.currentUser, (user) {
      isAuthenticated.value = user != null;
      if (user != null) {
        _checkRsvpStatus();
        _checkCreatorStatus();
      }
    });
  }

  void _checkRsvpStatus() {
    if (!isAuthenticated.value) return;
    
    final currentUser = Get.find<AuthService>().currentUser.value;
    if (currentUser != null && event.value != null) {
      isAttending.value = event.value!.attendees.contains(currentUser.uid);
      isNotAttending.value = !isAttending.value;
    }
  }

  void _checkCreatorStatus() {
    if (!isAuthenticated.value) return;
    
    final currentUser = Get.find<AuthService>().currentUser.value;
    if (currentUser != null && event.value != null) {
      isCreator.value = event.value!.createdBy == currentUser.uid;
    }
  }

  Future<void> rsvpToEvent(bool attending) async {
    if (!isAuthenticated.value) {
      showLoginPrompt();
      return;
    }

    final currentUser = Get.find<AuthService>().currentUser.value;
    if (currentUser == null || event.value == null) return;

    try {
      final updatedEvent = Event(
        id: event.value!.id,
        title: event.value!.title,
        description: event.value!.description,
        dateTime: event.value!.dateTime,
        location: event.value!.location,
        imageUrl: event.value!.imageUrl,
        createdBy: event.value!.createdBy,
        attendees: attending
            ? [...event.value!.attendees, currentUser.uid]
            : event.value!.attendees.where((id) => id != currentUser.uid).toList(),
        category: event.value!.category,
        createdOn: event.value!.createdOn,
        updatedOn: DateTime.now(),
      );

      await Get.find<FirestoreService>().updateEvent(updatedEvent);
      event.value = updatedEvent;
      _checkRsvpStatus();

      Get.snackbar(
        'Success',
        attending ? 'You are now attending this event!' : 'You are no longer attending this event.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update RSVP status.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void shareEvent() {
    // TODO: Implement share functionality
    Get.snackbar(
      'Share',
      'Event link copied to clipboard!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void editEvent() {
    if (!isAuthenticated.value) {
      showLoginPrompt();
      return;
    }
    Get.toNamed(AppRoutes.editEvent, arguments: event.value);
  }

  Future<void> deleteEvent() async {
    if (!isAuthenticated.value) {
      showLoginPrompt();
      return;
    }

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Get.find<FirestoreService>().deleteEvent(event.value!.id);
        Get.back();
        Get.snackbar(
          'Success',
          'Event deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to delete event.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void showLoginPrompt() {
    Get.dialog(
      AlertDialog(
        title: const Text('Login Required'),
        content: const Text('Please login to RSVP to events and access all features.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.toNamed(AppRoutes.login);
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
} 