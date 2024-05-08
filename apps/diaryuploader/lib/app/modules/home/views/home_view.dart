import 'package:diaryuploader/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_calendar_uploader/google_calendar_uploader.dart';

import '../../../controllers/secrets_controller.dart';
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
                final creds = await controller.signIn();
                if (creds == null) {
                  debugPrint('Could not Sign in');
                  return;
                }
                debugPrint('Signed in Successfully, ${creds.toJson()}');
                final uploader = GoogleCalenderUploader();
                final SecretsController secrets = Get.find();
                await uploader.init(secrets.clientId, secrets.clientSecret,
                    creds.accessToken, creds.tokenType!, creds.refreshToken);
                Get.put(uploader);
                Get.toNamed(Routes.CALENDAR_LIST);
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
