import 'dart:convert';

typedef Block = List<String>;

class BlockTaker {
  final List<Block> blockList = [];
  int index = 0;

  List<Block> get content => blockList.sublist(index);

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
  }

  /// 返回空说明已经完结了，
  Block? take() {
    if (index >= blockList.length) {
      return null;
    }
    return blockList[index++];
  }
}
