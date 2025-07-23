import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import '../controllers/my_rsvps_controller.dart';

class MyRsvpsView extends GetView<MyRsvpsController> {
  const MyRsvpsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(title: const Text('My RSVPs')),
      body: Obx(
        () => controller.isAuthenticated.value
            ? _buildRsvpsList()
            : _buildLoginRequired(),
      ),
    );
  }

  Widget _buildRsvpsList() {
    if (controller.rsvpEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80, color: Get.theme.disabledColor),
            const SizedBox(height: 16),
            Text('No RSVPs yet', style: Get.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'RSVP to events to see them here',
              style: Get.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.rsvpEvents.length,
      itemBuilder: (context, index) {
        final event = controller.rsvpEvents[index];
        final rsvpStatus = controller.getRsvpStatus(event);

        return GFCard(
          title: GFListTile(
            avatar: GFAvatar(backgroundImage: NetworkImage(event.imageUrl)),
            title: Text(event.title),
            subTitle: Text(event.description),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(event.dateTime.toString()),
                  const SizedBox(width: 8),
                  GFBadge(
                    text: rsvpStatus,
                    color: controller.getRsvpColor(event),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Text(event.location),
                ],
              ),
            ],
          ),
          buttonBar: GFButtonBar(
            children: [
              GFButton(
                onPressed: () => controller.goToEventDetails(event),
                text: 'View Details',
                type: GFButtonType.outline,
                size: GFSize.SMALL,
              ),
              GFButton(
                onPressed: () => controller.revokeRsvp(event),
                text: 'Revoke RSVP',
                type: GFButtonType.outline,
                color: GFColors.DANGER,
                size: GFSize.SMALL,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginRequired() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 80, color: Get.theme.disabledColor),
          const SizedBox(height: 16),
          Text('Login Required', style: Get.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Please login to view your RSVPs',
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
    );
  }
}
