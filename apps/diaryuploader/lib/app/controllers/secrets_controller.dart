import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class SecretsController extends GetxController {
  final String clientId;
  final String clientSecret;

  SecretsController(this.clientId, this.clientSecret);

  static Future<SecretsController> create() async {
    final dotenv = DotEnv();
    await dotenv.load(fileName: "secrets.env");
    final String clientId;
    final String clientSecret;
    if (GetPlatform.isWeb) {
      clientId = dotenv.env['GOOGLE_CLIENT_ID_WEB'] ?? '';
      clientSecret = dotenv.env['GOOGLE_CLIENT_SECRET_WEB'] ?? '';
    } else if (GetPlatform.isDesktop) {
      clientId = dotenv.env['GOOGLE_CLIENT_ID_DESKTOP'] ?? '';
      clientSecret = dotenv.env['GOOGLE_CLIENT_SECRET_DESKTOP'] ?? '';
    } else if (GetPlatform.isAndroid) {
      clientId = dotenv.env['GOOGLE_CLIENT_ID_WEB'] ?? '';
      clientSecret = dotenv.env['GOOGLE_CLIENT_SECRET_WEB'] ?? '';
    } else if (GetPlatform.isIOS) {
      clientId = dotenv.env['GOOGLE_CLIENT_ID_WEB'] ?? '';
      clientSecret = dotenv.env['GOOGLE_CLIENT_SECRET_WEB'] ?? '';
    } else {
      throw UnsupportedError('unknown platform');
    }
    return SecretsController(clientId, clientSecret);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
