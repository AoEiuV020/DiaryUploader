import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_calendar_uploader/google_calendar.dart';
import 'package:google_calendar_uploader/google_calendar_uploader.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

import 'secrets_controller.dart';

class GoogleSignInController extends GetxController {
  late GoogleSignIn _googleSignIn;
  final SecretsController secrets = Get.find();
  late final GoogleCalendar calender = Get.find();
  final logged = false.obs;
  final selected = false.obs;
  @override
  void onInit() {
    super.onInit();
    _googleSignIn = GoogleSignIn(
      params: GoogleSignInParams(
        clientId: secrets.clientId,
        clientSecret: secrets.clientSecret,
        redirectPort: 3000,
        scopes: ['https://www.googleapis.com/auth/calendar'],
      ),
    );
    logged.value = Get.isRegistered<GoogleCalendarUploader>();
  }

  Future<GoogleSignInCredentials?> signIn() async {
    final signInData = await _googleSignIn.signIn();
    if (signInData == null) {
      log('Could not Sign in');
      return null;
    }
    log('Signed in Successfully, ${signInData.toJson()}');
    final uploader = GoogleCalendarUploader();
    final SecretsController secrets = Get.find();
    await uploader.init(secrets.clientId, secrets.clientSecret,
        signInData.accessToken, signInData.tokenType!, signInData.refreshToken);
    Get.put(uploader);
    logged.value = true;
    return signInData;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    logged.value = false;
  }
}
