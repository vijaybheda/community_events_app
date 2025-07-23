import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import '../controllers/event_details_controller.dart';

class EventDetailsView extends GetView<EventDetailsController> {
  const EventDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: controller.shareEvent,
          ),
        ],
      ),
      body: Obx(() {
        final event = controller.event.value;
        if (event == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              if (event.imageUrl.isNotEmpty)
                GFCard(
                  image: Image(
                    height: 200,
                    image: NetworkImage(event.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),

              // Event Title
              Text(event.title, style: Get.textTheme.headlineMedium),
              const SizedBox(height: 8),

              // Event Info
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text(event.dateTime.toString()),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 8),
                  Text(event.location),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text('Description', style: Get.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(event.description),
              const SizedBox(height: 24),

              // RSVP Buttons - Show only for authenticated users
              Obx(
                () => controller.isAuthenticated.value
                    ? Row(
                        children: [
                          Expanded(
                            child: GFButton(
                              onPressed: () => controller.rsvpToEvent(true),
                              text: 'Attending',
                              type: GFButtonType.solid,
                              color: controller.isAttending.value
                                  ? GFColors.SUCCESS
                                  : GFColors.PRIMARY,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GFButton(
                              onPressed: () => controller.rsvpToEvent(false),
                              text: 'Not Attending',
                              type: GFButtonType.outline,
                              color: controller.isNotAttending.value
                                  ? GFColors.DANGER
                                  : GFColors.PRIMARY,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          GFButton(
                            onPressed: controller.showLoginPrompt,
                            text: 'Login to RSVP',
                            type: GFButtonType.solid,
                            color: GFColors.PRIMARY,
                            fullWidthButton: true,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Login to RSVP and manage your events',
                            style: Get.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),

              // Attendees - Show count for all, details for authenticated
              Text(
                'Attendees (${event.attendees.length})',
                style: Get.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Obx(
                () => controller.isAuthenticated.value
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.attendees.length,
                        itemBuilder: (context, index) {
                          final attendee = controller.attendees[index];
                          return GFListTile(
                            avatar: GFAvatar(
                              backgroundImage: NetworkImage(attendee.photoUrl),
                            ),
                            title: Text(attendee.name),
                            subTitle: Text(attendee.email),
                          );
                        },
                      )
                    : Text(
                        'Login to see attendees',
                        style: Get.textTheme.bodySmall,
                      ),
              ),
              const SizedBox(height: 24),

              // Edit/Delete for creator - Only for authenticated users
              Obx(
                () =>
                    controller.isAuthenticated.value &&
                        controller.isCreator.value
                    ? Row(
                        children: [
                          Expanded(
                            child: GFButton(
                              onPressed: controller.editEvent,
                              text: 'Edit Event',
                              type: GFButtonType.outline,
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GFButton(
                              onPressed: controller.deleteEvent,
                              text: 'Delete Event',
                              type: GFButtonType.outline,
                              color: GFColors.DANGER,
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
