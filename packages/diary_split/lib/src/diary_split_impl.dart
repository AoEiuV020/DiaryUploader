import 'dart:async';
import 'dart:convert';

import 'package:stream_taker/stream_taker.dart';

import '../diary_split.dart';
import 'block_taker.dart';
import 'date_time_parser.dart';

class DiarySplitImpl implements DiarySplit {
  @override
  String content = '';
  final parser = DateTimeParser();
  final blockTaker = BlockTaker();

  @override
  void append(String diaryDraft) {
    content += diaryDraft;
    blockTaker.append(diaryDraft);
  }

  @override
  Future<Diary> popDiary() async {
    final page = <String>[];
    DateTime? first;
    DateTime? start;
    DateTime? end;
    var stop = false;
    DateTime? previous;
    while (!stop) {
      final block = await blockTaker.take();
      for (var line in block) {
        final (current, text) = parser.parse(line);
        if (first == null && current != null) {
          first = current;
        }
        if (text.startsWith('起床')) {
          start = current;
        } else if (text.startsWith('醒')) {
          start = current;
        } else if (text.startsWith('睡觉')) {
          end = current;
          if (end != null && previous != null) {
            // 可空的end无法在while中保持智能推断的非空状态，
            while (end?.isBefore(previous) ?? false) {
              // 过了24点就跨天，
              end = end?.add(Duration(days: 1));
            }
          }
          stop = true;
        }
        page.add(line);
        previous = current ?? previous;
      }
    }
    start ??= first;
    start ??= parser.current;
    end ??= start.add(Duration(days: 1));
    return Diary(page.join('\n'), start, end);
  }

  @override
  set startTime(DateTime? value) {
    parser.current = value ?? DateTime.now();
  }
}
