import 'dart:collection';

import 'package:diary_split/diary_split.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_calendar_uploader/google_calendar_uploader.dart';
import 'package:intl/intl.dart';

import '../../../controllers/google_sign_in_controller.dart';

class DiarySplitController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final DateFormat dateFormat =
      DateFormat('yyyy-MM-dd(E)HH:mm:ss', Get.locale?.toString());
  final GoogleSignInController signIn = Get.find();

  /// 先确保logged在调用这个uploader,
  late final GoogleCalendarUploader uploader = Get.find();
  late final logged = signIn.logged;
  late final selected = signIn.selected;

  /// 剩下未处理的日记草稿段落列表，
  final diaryContent = <List<String>>[].obs;

  /// 当前加载出来的日记，
  late final currentDiary = defaultDiary().obs;
  final diarySplit = DiarySplit();
  final diaryCache = DoubleLinkedQueue<Diary>();
  @override
  void onInit() {
    super.onInit();
    currentDiary.stream.listen((event) {
      textController.text = event.content;
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Diary defaultDiary() {
    final now = DateTime.now();
    return Diary('', now.add(const Duration(days: -1)), now);
  }

  void append(String text) {
    diarySplit.append(text);
    diaryContent.value = diarySplit.content;
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
    currentDiary.value = currentDiary.value.copyWith(content: newText);
    diaryContent.value = diarySplit.content;
    return selectedText;
  }

  void previous() {
    diarySplit.back(textController.text);
    if (diaryCache.isEmpty) {
      return;
    }
    final diary = diaryCache.removeLast();
    currentDiary.value = diary;
    diaryContent.value = diarySplit.content;
  }

  void next() async {
    final diary = await diarySplit.popDiary();
    currentDiary.value =
        currentDiary.value.copyWith(content: textController.text);
    diaryCache.addLast(currentDiary.value);
    currentDiary.value = diary;
    diaryContent.value = diarySplit.content;
  }

  void upload() {
    currentDiary.value =
        currentDiary.value.copyWith(content: textController.text);
    final diary = currentDiary.value;
    uploader.insert(
      diary.start.millisecondsSinceEpoch,
      diary.end.millisecondsSinceEpoch,
      diary.content,
    );
  }

  void setNextDiaryTime(DateTime nextTime) {
    diarySplit.startTime = nextTime;
  }

  String timeToString(DateTime value) {
    return dateFormat.format(value);
  }
}
