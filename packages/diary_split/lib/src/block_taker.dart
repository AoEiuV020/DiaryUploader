import 'dart:convert';

typedef Block = List<String>;

class BlockTaker {
  final List<Block> blockList = [];
  int index = 0;

  List<Block> get content => blockList.sublist(index);

  /// 在开头插入，
  void back(String text) {
    final lineList = const LineSplitter().convert(text);
    final List<Block> tmpList = [];
    var block = <String>[];
    for (var line in lineList) {
      if (line.trim().isEmpty) {
        if (block.isEmpty) {
          continue;
        } else {
          tmpList.add(block);
          block = [];
        }
      } else {
        block.add(line);
      }
    }
    if (block.isNotEmpty) {
      tmpList.add(block);
    }
    blockList.insertAll(index, tmpList);
  }

  /// 在末尾插入，
  void append(String text) async {
    final lineList = const LineSplitter().convert(text);
    var block = <String>[];
    for (var line in lineList.reversed) {
      if (line.trim().isEmpty) {
        if (block.isEmpty) {
          continue;
        } else {
          blockList.add(block.reversed.toList());
          block = [];
        }
      } else {
        block.add(line);
      }
    }
    if (block.isNotEmpty) {
      blockList.add(block.reversed.toList());
    }
  }

  /// 返回空说明已经完结了，
  Block? take() {
    if (index >= blockList.length) {
      return null;
    }
    return blockList[index++];
  }
}
