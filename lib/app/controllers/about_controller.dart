import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutController extends GetxController {
  Future<void> sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@communityevents.com',
      query: 'subject=Community Events App Support',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not open email app',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> openWebsite() async {
    final Uri websiteUri = Uri.parse('https://www.communityevents.com');

    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open website',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> openGitHub() async {
    final Uri githubUri = Uri.parse('https://github.com/communityevents');

    if (await canLaunchUrl(githubUri)) {
      await launchUrl(githubUri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open GitHub',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
