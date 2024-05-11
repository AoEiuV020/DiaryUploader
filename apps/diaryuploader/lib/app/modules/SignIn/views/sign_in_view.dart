import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/google_sign_in_controller.dart';

class SignInView extends GetView<GoogleSignInController> {
  const SignInView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录谷歌')),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Obx(() => Text(controller.logged.value ? '已登录' : '未登录')),
            Obx(() => !controller.logged.value
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: controller.selectCalendar,
                      child: Obx(() => Text(controller.selected.value
                          ? controller.calendar.name
                          : '选择日历本')),
                    ),
                  )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final signInData = await controller.signIn();
                if (signInData == null) {
                  return;
                }
                controller.selectCalendar();
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  await controller.signOut();
                  debugPrint('Signed Out Successfully');
                } catch (err) {
                  debugPrint('Could not Sign Out');
                }
              },
              child: const Text('Sign Out'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
