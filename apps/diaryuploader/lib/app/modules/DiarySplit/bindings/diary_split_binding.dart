import 'package:get/get.dart';

import '../controllers/diary_split_controller.dart';

class DiarySplitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiarySplitController>(
      () => DiarySplitController(),
    );
  }
}
