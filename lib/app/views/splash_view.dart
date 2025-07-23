import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Replace with your app logo asset
            Icon(Icons.event, size: 80, color: Get.theme.primaryColor),
            const SizedBox(height: 24),
            Text('Community Events', style: Get.textTheme.headlineMedium),
            const SizedBox(height: 32),
            const GFLoader(type: GFLoaderType.circle),
          ],
        ),
      ),
    );
  }
}
