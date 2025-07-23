import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/event.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class AddEventController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  final selectedCategory = 'General'.obs;
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final selectedImage = Rxn<File>();
  final isFormValid = false.obs;
  final isAuthenticated = false.obs;

  final categories = [
    'General',
    'Sports',
    'Music',
    'Technology',
    'Food',
    'Art',
    'Business',
    'Education',
  ];

  @override
  void onInit() {
    super.onInit();
    _checkAuthenticationStatus();
    ever(selectedCategory, (_) => _validateForm());
    ever(selectedDate, (_) => _validateForm());
    ever(selectedTime, (_) => _validateForm());
    ever(selectedImage, (_) => _validateForm());
  }

  void _checkAuthenticationStatus() {
    final authService = Get.find<AuthService>();
    isAuthenticated.value = authService.currentUser.value != null;

    // Listen to auth state changes
    ever(authService.currentUser, (user) {
      isAuthenticated.value = user != null;
    });
  }

  void onCategoryChanged(String? category) {
    if (category != null) {
      selectedCategory.value = category;
    }
  }

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      selectedDate.value = date;
    }
  }

  Future<void> selectTime() async {
    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      selectedTime.value = time;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  void _validateForm() {
    isFormValid.value =
        titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        selectedDate.value != null &&
        selectedTime.value != null;
  }

  Future<void> saveEvent() async {
    if (!isAuthenticated.value) {
      Get.snackbar('Error', 'Please login to create events');
      return;
    }

    if (!formKey.currentState!.validate() || !isFormValid.value) {
      return;
    }

    try {
      final currentUser = Get.find<AuthService>().currentUser.value;
      if (currentUser == null) {
        Get.snackbar('Error', 'Please login to create an event');
        return;
      }

      // Combine date and time
      final dateTime = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        selectedTime.value!.hour,
        selectedTime.value!.minute,
      );

      // Upload image if selected
      String imageUrl = '';
      if (selectedImage.value != null) {
        imageUrl = await Get.find<StorageService>().uploadEventImage(
          selectedImage.value!,
          DateTime.now().millisecondsSinceEpoch.toString(),
        );
      }

      final event = Event(
        id: '',
        title: titleController.text,
        description: descriptionController.text,
        dateTime: dateTime,
        location: locationController.text,
        imageUrl: imageUrl,
        createdBy: currentUser.uid,
        attendees: [],
        category: selectedCategory.value,
        createdOn: DateTime.now(),
        updatedOn: DateTime.now(),
      );

      await Get.find<FirestoreService>().addEvent(event);

      Get.back();
      Get.snackbar(
        'Success',
        'Event created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create event. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
