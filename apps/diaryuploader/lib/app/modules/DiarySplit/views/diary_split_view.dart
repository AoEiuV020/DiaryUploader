import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/diary_split_controller.dart';
import 'diary_left_view.dart';

class DiarySplitView extends GetView<DiarySplitController> {
  const DiarySplitView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diary split')),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.SIGN_IN);
                },
                child: Obx(() => Text(controller.logged.value ? '已登录' : '未登录')),
              ),
            ],
          ),
              Obx(() => Text('当前日记草稿段落： ${controller.diaryContent.length}')),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // 左侧时间控件
              TextButton(
                onPressed: () {
                  _selectDate(context, controller.currentDiary.value.start,
                      (date) {
                    controller.currentDiary.value =
                        controller.currentDiary.value.copyWith(start: date);
                  });
                },
                child: Obx(() => Text(controller
                    .timeToString(controller.currentDiary.value.start))),
              ),
              // 中间横线
              Container(
                width: 100.0, // 可以根据需要调整横线的长度
                height: 2.0, // 横线的宽度
                color: Colors.black, // 横线的颜色
              ),
              // 右侧时间控件
              TextButton(
                onPressed: () {
                  _selectDate(context, controller.currentDiary.value.end,
                      (date) {
                    controller.currentDiary.value =
                        controller.currentDiary.value.copyWith(end: date);
                    controller.setNextDiaryTime(date);
                  });
                },
                child: Obx(() => Text(controller
                    .timeToString(controller.currentDiary.value.end))),
              ),
            ],
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              const minHeight = 80.0;
              return Column(
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight - minHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller.textController,
                        maxLines: null, // 允许多行文本
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '等待下一篇日记',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    constraints: const BoxConstraints(minHeight: minHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() =>
                          DiaryLeftWidget(controller.diaryContent.toList())),
                    ),
                  )),
                ],
              );
            }),
          ),
          // 一排按钮
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _showDialogAndPasteText(context),
                child: const Text('输入日记草稿'),
              ),
              ElevatedButton(
                onPressed: () {
                  final selected = controller.back();
                  if (selected.isEmpty) {
                    Get.defaultDialog(
                      title: '错误',
                      middleText: '请先选择文本',
                      textConfirm: '确定',
                      onConfirm: Get.back,
                    );
                  }
                },
                child: const Text('放回选中部分'),
              ),
              ElevatedButton(
                onPressed: controller.previous,
                child: const Text('前一篇'),
              ),
              ElevatedButton(
                onPressed: controller.next,
                child: const Text('下一篇'),
              ),
              // 可以根据需要添加更多的按钮
            ],
          ),
          Obx(() => Visibility(
                visible: controller.logged.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: controller.upload,
                    child: const Text('上传日记'),
                  ),
                ),
              )),
          const SizedBox.square(dimension: 8)
        ],
      ),
    );
  }

  void _selectDate(BuildContext context, DateTime date,
      void Function(DateTime date) callback) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(date),
      );
      if (pickedTime != null) {
        callback(DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        ));
      }
    }
  }

  void _showDialogAndPasteText(BuildContext context) {
    // 使用Get.dialog创建模态对话框
    final TextEditingController dialogTextController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('请输入文本'),
        content: TextField(
          controller: dialogTextController,
          maxLines: null, // 允许多行文本
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '输入一些文本',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // 关闭对话框
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // 将输入的文本粘贴到大文本框里
              controller.append(dialogTextController.text);
              Get.back(); // 关闭对话框
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
