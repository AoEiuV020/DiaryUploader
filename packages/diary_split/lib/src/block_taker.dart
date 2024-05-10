import 'dart:async';
import 'dart:convert';

import 'package:stream_taker/stream_taker.dart';

class BlockTaker {
  final inputStreamController = StreamController<String>();
  late final lineTaker = StreamTaker(inputStreamController.stream);

  void append(String text) async {
    inputStreamController.addStream(reversedStream(text));
  }

  Stream<String> reversedStream(String text) async* {
    final lineList =
        await Stream.value(text).transform(LineSplitter()).toList();
    yield* Stream.fromIterable(lineList.reversed);
  }

  /// 返回空数组说明已经完结了，
  Future<List<String>> take() async {
    final block = <String>[];
    while (true) {
      String line;
      try {
        line = await lineTaker.takeOne();
      } catch (e) {
        break;
      }
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
