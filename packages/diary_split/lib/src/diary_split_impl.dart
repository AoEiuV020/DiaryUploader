import 'dart:async';

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
    while (!stop) {
      final block = blockTaker.take();
      if (block == null) {
        stop = true;
        break;
      }
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
          stop = true;
        }
        page.add(line);
      }
    }
    start ??= first;
    start ??= parser.current;
    end ??= start.add(Duration(days: 1));
    parser.current = end;
    return Diary(page.join('\n'), start, end);
  }

  @override
  set startTime(DateTime? value) {
    parser.current = value ?? DateTime.now();
  }
}
