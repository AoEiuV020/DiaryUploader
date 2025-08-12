import 'dart:async';
import 'dart:convert';

import '../diary_split.dart';
import 'block_taker.dart';
import 'date_time_parser.dart';
import 'diary_parse_result.dart';

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

  Stream<(String, DateTime?, String)> _parseLines(Stream<String> lines) async* {
    await for (final line in lines) {
      final (current, text) = parser.parse(line);
      yield (line, current, text);
    }
  }

  DiaryParseResult _accumulate(List<(String, DateTime?, String)> parsedLines) {
    String? title;
    DateTime? first;
    DateTime? start;
    DateTime? end;

    for (var (_, current, text) in parsedLines) {
      if (first == null && current != null) {
        first = current;
      }
      if (text.contains('上班') || text.contains('下班')) {
        title = '上班';
      }
      if (start == null) {
        if (text.startsWith('起床') || text.startsWith('醒')) {
          start = current;
        }
      }
      if (text.startsWith('睡觉')) {
        end = current;
      }
    }

    title ??= '咸鱼';
    start ??= first;
    start ??= parser.current;
    end ??= start.add(Duration(days: 1));

    return DiaryParseResult(
      title: title,
      start: start,
      end: end,
      first: first,
    );
  }

  @override
  Future<Diary> popDiary() async {
    final lines = <String>[];
    final parsedLines = <(String, DateTime?, String)>[];
    var foundSleep = false;

    while (!foundSleep) {
      final block = blockTaker.take();
      if (block == null) break;

      await for (final parsed in _parseLines(Stream.fromIterable(block))) {
        final (line, _, text) = parsed;
        lines.add(line);
        parsedLines.add(parsed);
        if (text.startsWith('睡觉')) {
          foundSleep = true;
          break;
        }
      }
    }

    final result = _accumulate(parsedLines);
    parser.current =
        result.end ?? result.start?.add(Duration(days: 1)) ?? parser.current;

    return Diary(
      result.title,
      lines.join('\n'),
      result.start ?? parser.current,
      result.end ?? (result.start?.add(Duration(days: 1)) ?? parser.current),
    );
  }

  @override
  Diary parse(DateTime from, String content) {
    startTime = from;
    final lines = const LineSplitter().convert(content);
    // 同步方式收集所有解析结果
    final parsedLines = <(String, DateTime?, String)>[];
    for (final line in lines) {
      final (current, text) = parser.parse(line);
      parsedLines.add((line, current, text));
    }

    final result = _accumulate(parsedLines);
    parser.current =
        result.end ?? result.start?.add(Duration(days: 1)) ?? parser.current;
    return Diary(
      result.title,
      content,
      result.start ?? parser.current,
      result.end ?? (result.start?.add(Duration(days: 1)) ?? parser.current),
    );
  }

  @override
  set startTime(DateTime? value) {
    parser.current = value ?? DateTime.now();
  }
}
