import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testing Application')),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                Get.toNamed(Routes.DIARY_SPLIT);
              },
              child: const Text('Diary Split'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Get.toNamed(Routes.SIGN_IN);
              },
              child: const Text('Google SignIn'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
