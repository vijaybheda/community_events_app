import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: GFAppBar(
          title: const Text('Community Events'),
          actions: [
            // Show login button for guests, profile for authenticated users
            Obx(
              () => controller.isAuthenticated.value
                  ? IconButton(
                      icon: const Icon(Icons.account_circle),
                      onPressed: controller.goToProfile,
                    )
                  : GFButton(
                      onPressed: controller.goToLogin,
                      text: 'Login',
                      type: GFButtonType.outline,
                      size: GFSize.SMALL,
                    ),
            ),
            // Show add event button only for authenticated users
            Obx(
              () => controller.isAuthenticated.value
                  ? IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: controller.goToAddEvent,
                    )
                  : const SizedBox(),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Events'),
              Tab(text: 'My RSVP'),
              Tab(text: 'Past Events'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GFSearchBar(
                searchList: controller.eventTitles,
                searchQueryBuilder: controller.searchEvents,
                overlaySearchListItemBuilder: (item) =>
                    ListTile(title: Text(item)),
                onItemSelected: controller.onEventSelected,
              ),
            ),
            Expanded(
              child: Obx(
                () => RefreshIndicator(
                  onRefresh: controller.refreshEvents,
                  child: ListView.builder(
                    itemCount: controller.events.length,
                    itemBuilder: (context, index) {
                      final event = controller.events[index];
                      return GFCard(
                        title: GFListTile(
                          avatar: GFAvatar(
                            backgroundImage: NetworkImage(event.imageUrl),
                          ),
                          title: Text(event.title),
                          subTitle: Text(event.description),
                        ),
                        content: GestureDetector(
                          onTap: () => controller.goToEventDetails(event),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16),
                                  const SizedBox(width: 4),
                                  Text(event.dateTime.toString()),
                                  const SizedBox(width: 8),
                                  // Show RSVP status only for authenticated users
                                  if (controller.isAuthenticated.value)
                                    GFBadge(
                                      text: controller.getRsvpStatus(event),
                                      color: controller.getRsvpColor(event),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
