import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: controller.goToSettings,
          ),
        ],
      ),
      body: Obx(
        () => controller.isAuthenticated.value
            ? _buildProfileContent()
            : _buildLoginRequired(),
      ),
    );
  }

  Widget _buildProfileContent() {
    final user = controller.currentUser.value;
    if (user == null) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // User Avatar and Info
          GFCard(
            content: Column(
              children: [
                GFAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                const SizedBox(height: 16),
                Text(user.name, style: Get.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(user.email, style: Get.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Profile Actions
          GFCard(
            content: Column(
              children: [
                GFListTile(
                  title: const Text('Edit Profile'),
                  onTap: controller.editProfile,
                ),
                const Divider(),
                GFListTile(
                  title: const Text('My Events'),
                  onTap: controller.goToMyEvents,
                ),
                const Divider(),
                GFListTile(
                  title: const Text('My RSVPs'),
                  onTap: controller.goToMyRsvps,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // App Settings
          GFCard(
            content: Column(
              children: [
                GFListTile(
                  title: const Text('Language'),
                  onTap: controller.changeLanguage,
                ),
                const Divider(),
                GFListTile(
                  title: const Text('Theme'),
                  onTap: controller.changeTheme,
                ),
                const Divider(),
                GFListTile(
                  title: const Text('About'),
                  onTap: controller.goToAbout,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: GFButton(
              onPressed: controller.logout,
              text: 'Logout',
              type: GFButtonType.solid,
              color: GFColors.DANGER,
              size: GFSize.LARGE,
            ),
          ),
        ],
      ),
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
            'Please login to access your profile',
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
