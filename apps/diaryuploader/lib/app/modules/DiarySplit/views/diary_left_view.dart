import 'package:flutter/material.dart';

class DiaryLeftWidget extends StatelessWidget {
  final List<List<String>> content;

  const DiaryLeftWidget(this.content, {super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: content.length,
      itemBuilder: (context, index) {
        final block = content[index];
        return ListView.builder(
          shrinkWrap: true,
          itemCount: block.length,
          itemBuilder: (context, index) {
            final line = block[index];
            return Text(
              line,
              style: TextStyle(
                color: Colors.grey[400], // 使用灰色系列颜色
              ),
            );
          },
        );
      },
    );
  }
}
