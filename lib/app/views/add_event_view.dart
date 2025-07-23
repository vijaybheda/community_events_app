import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import '../controllers/add_event_controller.dart';

class AddEventView extends GetView<AddEventController> {
  const AddEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text('Add Event'),
        actions: [
          Obx(
            () => controller.isFormValid.value
                ? GFButton(
                    onPressed: controller.saveEvent,
                    text: 'Save',
                    type: GFButtonType.solid,
                    size: GFSize.SMALL,
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Obx(
        () => controller.isAuthenticated.value
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      GFTextField(
                        controller: controller.titleController,
                        decoration: const InputDecoration(
                          labelText: 'Event Title',
                          border: OutlineInputBorder(),
                        ),
                        validatornew: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter event title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description
                      GFTextField(
                        controller: controller.descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validatornew: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter event description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category
                      GFDropdown<String>(
                        value: controller.selectedCategory.value,
                        items: controller.categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                        onChanged: controller.onCategoryChanged,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 16),

                      // Location
                      GFTextField(
                        controller: controller.locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                        validatornew: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter event location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date and Time
                      Row(
                        children: [
                          Expanded(
                            child: GFButton(
                              onPressed: controller.selectDate,
                              text:
                                  'Date: ${controller.selectedDate.value ?? "Select Date"}',
                              type: GFButtonType.outline,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GFButton(
                              onPressed: controller.selectTime,
                              text:
                                  'Time: ${controller.selectedTime.value ?? "Select Time"}',
                              type: GFButtonType.outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Image Upload
                      Obx(
                        () => controller.selectedImage.value != null
                            ? Column(
                                children: [
                                  Image.file(controller.selectedImage.value!),
                                  const SizedBox(height: 8),
                                  GFButton(
                                    onPressed: controller.removeImage,
                                    text: 'Remove Image',
                                    type: GFButtonType.outline,
                                    color: GFColors.DANGER,
                                  ),
                                ],
                              )
                            : GFButton(
                                onPressed: controller.pickImage,
                                text: 'Add Image',
                                type: GFButtonType.outline,
                                icon: const Icon(Icons.image),
                              ),
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => GFButton(
                            onPressed: controller.isFormValid.value
                                ? controller.saveEvent
                                : null,
                            text: 'Create Event',
                            type: GFButtonType.solid,
                            color: GFColors.SUCCESS,
                            size: GFSize.LARGE,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 80, color: Get.theme.disabledColor),
                    const SizedBox(height: 16),
                    Text('Login Required', style: Get.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      'Please login to create events',
                      style: Get.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    GFButton(
                      onPressed: () => Get.toNamed('/login'),
                      text: 'Login',
                      type: GFButtonType.solid,
                      color: GFColors.PRIMARY,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
