import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DiarySplitController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final text = ''.obs;
  @override
  void onInit() {
    super.onInit();
    text.stream.listen((event) {
      textController.text = event;
    });
  }


}
