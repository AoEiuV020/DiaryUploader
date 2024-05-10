import 'package:diary_split/diary_split.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiarySplitController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final diaryContent = ''.obs;
  final nextContent = ''.obs;
  final nextStartTime = DateTime.now().add(const Duration(days: -1)).obs;
  final nextEndTime = DateTime.now().obs;
  final diaryLength = 0.obs;
  final diarySplit = DiarySplit();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  @override
  void onInit() {
    super.onInit();
    nextContent.stream.listen((event) {
      textController.text = event;
    });
  }

  void append(String text) {
    diarySplit.append(text);
    updateContent();
  }

  void updateContent() {
    diaryContent.value = diarySplit.contentText;
    diaryLength.value = diaryContent.value.length;
  }

  void next() async {
    final diary = await diarySplit.popDiary();
    nextContent.value = diary.content;
    nextStartTime.value = diary.start;
    nextEndTime.value = diary.end;
  }

  String timeToString(DateTime value) {
    return dateFormat.format(value);
  }
}
