import 'package:get/get.dart';

import '../controllers/calendar_list_controller.dart';

class CalendarListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarListController>(
      () => CalendarListController(),
    );
  }
}
