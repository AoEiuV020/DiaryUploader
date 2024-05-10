import 'package:intl/date_symbol_data_local.dart';

import 'app/controllers/secrets_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => SecretsController.create());
  initializeDateFormatting(Get.deviceLocale.toString());
  runApp(
    GetMaterialApp(
      title: "Application",
      locale: Get.deviceLocale,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
