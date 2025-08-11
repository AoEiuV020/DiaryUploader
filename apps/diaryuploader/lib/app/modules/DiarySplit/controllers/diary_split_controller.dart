import 'dart:collection';

import 'package:diary_split/diary_split.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_calendar_uploader/google_calendar.dart';
import 'package:google_calendar_uploader/google_calendar_uploader.dart';
import 'package:intl/intl.dart';

import '../../../controllers/google_sign_in_controller.dart';
import '../../../routes/app_pages.dart';

class DiarySplitController extends GetxController {
  /// 显示提示信息，新的提示会立即覆盖旧的提示
  void showTip(String title, String message) {
    Get.closeAllSnackbars();
    Get.rawSnackbar(
      title: title,
      message: message,
      duration: const Duration(milliseconds: 1500),
      snackPosition: SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 150),
      borderRadius: 8,
      isDismissible: true,
      overlayBlur: 0,
      margin: const EdgeInsets.all(8),
    );
  }

  final TextEditingController textController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final DateFormat dateFormat =
      DateFormat('yyyy-MM-dd(E)HH:mm:ss', Get.locale?.toString());
  final GoogleSignInController signIn = Get.find();
  late final GoogleCalendar calendar = Get.find();

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

  /// 成功上传的日记的id保存起来，
  final eventIdCache = DoubleLinkedQueue<String>();
  @override
  void onInit() {
    super.onInit();
    currentDiary.stream.listen((event) {
      textController.text = event.content;
      titleController.text = event.title;
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Diary defaultDiary() {
    final now = DateTime.now();
    return Diary('', '', now.add(const Duration(days: -1)), now);
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
    diarySplit.startTime = currentDiary.value.end;
    final diary = await diarySplit.popDiary();
    updateCurrentText();
    diaryCache.addLast(currentDiary.value);
    currentDiary.value = diary;
    diaryContent.value = diarySplit.content;
  }

  void updateCurrentText() {
    currentDiary.value = currentDiary.value.copyWith(
      title: titleController.text,
      content: textController.text,
    );
  }

  void parse() {
    updateCurrentText();
    diarySplit.startTime = currentDiary.value.start;
    final result =
        diarySplit.parse(currentDiary.value.start, currentDiary.value.content);
    currentDiary.value = result;
  }

  void upload() async {
    if (!selected.value) {
      Get.defaultDialog(
          title: '错误',
          middleText: '请先选择日历',
          textConfirm: '去选择',
          onConfirm: () {
            Get.back();
            Get.toNamed(Routes.SIGN_IN);
          });
      return;
    }
    uploader.setSelectedCalendar(calendar);
    updateCurrentText();
    final diary = currentDiary.value;
    try {
      final result = await uploader.insert(
        diary.title,
        diary.content,
        diary.start,
        diary.end,
      );
      showTip('上传成功', '${timeToString(diary.start)}\n$result');
    } catch (e) {
      showTip('上传失败', e.toString());
    }
  }

  void setNextDiaryTime(DateTime nextTime) {
    diarySplit.startTime = nextTime;
  }

  String timeToString(DateTime value) {
    return dateFormat.format(value);
  }
}
