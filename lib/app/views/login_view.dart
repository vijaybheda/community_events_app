import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO: Replace with your app logo asset
              Icon(Icons.event, size: 80, color: Get.theme.primaryColor),
              const SizedBox(height: 24),
              Text('Community Events', style: Get.textTheme.headlineMedium),
              const SizedBox(height: 32),
              GFButton(
                onPressed: controller.signInWithGoogle,
                text: 'Sign in with Google',
                icon: const Icon(Icons.login),
                type: GFButtonType.solid,
                color: GFColors.PRIMARY,
                fullWidthButton: true,
              ),
              const SizedBox(height: 16),
              Obx(
                () => controller.error.value.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error, color: Colors.white),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                controller.error.value,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
