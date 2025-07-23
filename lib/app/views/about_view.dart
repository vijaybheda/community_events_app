import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info
            GFCard(
              content: Column(
                children: [
                  Icon(Icons.event, size: 80, color: Get.theme.primaryColor),
                  const SizedBox(height: 16),
                  Text('Community Events', style: Get.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Version 1.0.0', style: Get.textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  Text(
                    'Connect with your community through events. Discover, create, and participate in local events that matter to you.',
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // FAQ Section
            Text('Frequently Asked Questions', style: Get.textTheme.titleLarge),
            const SizedBox(height: 16),
            GFAccordion(
              titleChild: const Text('How do I create an event?'),
              contentChild: const Text(
                'To create an event, tap the "+" button on the home screen. Fill in the event details including title, description, location, date, and time. You can also add an image to make your event more attractive.',
              ),
            ),
            GFAccordion(
              titleChild: const Text('How do I RSVP to an event?'),
              contentChild: const Text(
                'To RSVP to an event, tap on the event card to view details. Then tap either "Attending" or "Not Attending" button to update your RSVP status.',
              ),
            ),
            GFAccordion(
              titleChild: const Text('Can I edit or delete my events?'),
              contentChild: const Text(
                'Yes, you can edit or delete events that you created. On the event details page, you will see "Edit Event" and "Delete Event" buttons if you are the creator of the event.',
              ),
            ),
            GFAccordion(
              titleChild: const Text('How do I search for events?'),
              contentChild: const Text(
                'Use the search bar at the top of the home screen to search for events by title, description, or category. You can also filter events using the tabs.',
              ),
            ),
            const SizedBox(height: 24),

            // Contact Section
            Text('Contact Us', style: Get.textTheme.titleLarge),
            const SizedBox(height: 16),
            GFCard(
              content: Column(
                children: [
                  GFListTile(
                    title: const Text('Email'),
                    onTap: controller.sendEmail,
                  ),
                  const Divider(),
                  GFListTile(
                    title: const Text('Website'),
                    onTap: controller.openWebsite,
                  ),
                  const Divider(),
                  GFListTile(
                    title: const Text('GitHub'),
                    onTap: controller.openGitHub,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Features Section
            Text('Features', style: Get.textTheme.titleLarge),
            const SizedBox(height: 16),
            GFCard(
              content: Column(
                children: [
                  _buildFeatureItem(
                    Icons.event,
                    'Create Events',
                    'Create and manage community events',
                  ),
                  _buildFeatureItem(
                    Icons.people,
                    'RSVP System',
                    'Easily RSVP to events you want to attend',
                  ),
                  _buildFeatureItem(
                    Icons.search,
                    'Search & Filter',
                    'Find events by category, date, or keyword',
                  ),
                  _buildFeatureItem(
                    Icons.share,
                    'Share Events',
                    'Share events with friends and family',
                  ),
                  _buildFeatureItem(
                    Icons.notifications,
                    'Real-time Updates',
                    'Get instant updates on event changes',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Get.theme.primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Get.textTheme.titleMedium),
                Text(description, style: Get.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
