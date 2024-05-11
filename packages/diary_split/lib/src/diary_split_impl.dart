import 'dart:async';
import 'dart:convert';

import '../diary_split.dart';
import 'block_taker.dart';
import 'date_time_parser.dart';

class DiarySplitImpl implements DiarySplit {
  final parser = DateTimeParser();
  final blockTaker = BlockTaker();

  @override
  List<List<String>> get content => blockTaker.content;

  @override
  String get contentText => content.map((e) => e.join('\n')).join('\n');

  @override
  void append(String diaryDraft) {
    blockTaker.append(diaryDraft);
  }

  @override
  void back(String text) {
    blockTaker.back(text);
  }

  @override
  Future<Diary> popDiary() async {
    final page = <String>[];
    String? title;
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
        if (text.contains('上班')) {
          title = '上班';
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
    title ??= '咸鱼';
    start ??= first;
    start ??= parser.current;
    end ??= start.add(Duration(days: 1));
    parser.current = end;
    return Diary(title, page.join('\n'), start, end);
  }

  @override
  Diary parse(DateTime from, String content) {
    final lineList = const LineSplitter().convert(content);
    startTime = from;
    final page = <String>[];
    String? title;
    DateTime? first;
    DateTime? start;
    DateTime? end;
    for (var line in lineList) {
      final (current, text) = parser.parse(line);
      if (first == null && current != null) {
        first = current;
      }
      if (text.contains('上班')) {
        title = '上班';
      }
      if (text.startsWith('起床')) {
        start = current;
      } else if (text.startsWith('醒')) {
        start = current;
      } else if (text.startsWith('睡觉')) {
        end = current;
      }
      page.add(line);
    }
    title ??= '咸鱼';
    start ??= parser.current;
    end ??= start.add(Duration(days: 1));
    parser.current = end;
    return Diary(title, content, start, end);
  }

  @override
  set startTime(DateTime? value) {
    parser.current = value ?? DateTime.now();
  }
}
