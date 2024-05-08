import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/diary_split_controller.dart';

class DiarySplitView extends GetView<DiarySplitController> {
  const DiarySplitView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diary split')),
      body: Column(
        children: <Widget>[
          Obx(() => Text('当前日记草稿长度： ${controller.diaryLength}')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 左侧时间控件
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => Text(
                    controller.timeToString(controller.nextStartTime.value))),
              ),
              // 中间横线
              Container(
                width: 100.0, // 可以根据需要调整横线的长度
                height: 2.0, // 横线的宽度
                color: Colors.black, // 横线的颜色
              ),
              // 右侧时间控件
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => Text(
                    controller.timeToString(controller.nextEndTime.value))),
              ),
            ],
          ),
          // 大文本框
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller.textController,
                maxLines: null, // 允许多行文本
                expands: true,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '等待下一篇日记',
                ),
              ),
            ),
          ),
          // 一排按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _showDialogAndPasteText(context),
                child: const Text('输入'),
              ),
              const SizedBox(width: 10), // 用于设置按钮之间的间距
              ElevatedButton(
                onPressed: controller.next,
                child: const Text('下一篇'),
              ),
              // 可以根据需要添加更多的按钮
            ],
          ),
          const SizedBox.square(dimension: 8)
        ],
      ),
    );
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
