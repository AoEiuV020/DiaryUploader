import 'package:diary_split/diary_split.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiarySplitController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final diaryContent = <List<String>>[].obs;
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

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void append(String text) {
    diarySplit.append(text);
    updateContent();
  }

  void updateContent() {
    diaryContent.value = diarySplit.content;
    diaryLength.value = diaryContent.length;
  }

  String back() {
    var start = textController.selection.base.offset;
    var end = textController.selection.extent.offset;
    if (start < 0 || end < 0) {
      return '';
    }
    // 从下往上拉时start会比end大，
    if (start > end) {
      (start, end) = (end, start);
    }
    final text = textController.text;
    final selectedText = text.substring(start, end);
    final newText = text.replaceRange(start, end, '');
    diarySplit.back(selectedText);
    nextContent.value = newText;
    updateContent();
    return selectedText;
  }

  void next() async {
    final diary = await diarySplit.popDiary();
    nextContent.value = diary.content;
    nextStartTime.value = diary.start;
    nextEndTime.value = diary.end;
    updateContent();
  }

  void setNextDiaryTime(DateTime nextTime) {
    diarySplit.startTime = nextTime;
  }

  String timeToString(DateTime value) {
    return dateFormat.format(value);
  }
}
