import 'dart:async';
import 'dart:collection';
import 'dart:convert';

class BlockTaker {
  final queue = Queue();

  void append(String text) async {
    final lineList = const LineSplitter().convert(text);
    queue.addAll(lineList.reversed);
  }

  /// 返回空数组说明已经完结了，
  Future<List<String>> take() async {
    final block = <String>[];
    while (queue.isNotEmpty) {
      String line;
      line = queue.removeFirst();
      if (line.trim().isEmpty) {
        if (block.isEmpty) {
          continue;
        } else {
          break;
        }
      }
      block.add(line);
    }
    return block.reversed.toList();
  }
}
