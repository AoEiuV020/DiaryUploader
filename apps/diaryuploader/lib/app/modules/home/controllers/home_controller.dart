import 'package:diaryuploader/app/controllers/secrets_controller.dart';
import 'package:get/get.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

class HomeController extends GetxController {
  late GoogleSignIn _googleSignIn;
  final SecretsController secrets = Get.find();
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
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<GoogleSignInCredentials?> signIn() =>
      _googleSignIn.signIn();

  Future<void> signOut() => _googleSignIn.signOut();
}
