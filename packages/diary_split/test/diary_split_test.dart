import 'package:diary_split/diary_split.dart';
import 'package:diary_split/src/date_time_parser.dart';
import 'package:test/test.dart';

void main() {
  final year = DateTime.now().year;
  group('date format test', () {
    final parser = DateTimeParser();
    test('start time parse', () {
      final (date, text) = parser.parse('9月28日');
      expect(date.toString(), '$year-09-28 00:00:00.000');
      expect(text, '');
    });
    test('time without seconds text parse', () {
      final (date, text) = parser.parse('15:11 打个喷嚏，');
      expect(date.toString(), '$year-09-28 15:11:00.000');
      expect(text, '打个喷嚏，');
    });
    test('time text parse', () {
      final (date, text) = parser.parse('18:31:32 打卡，下班，');
      expect(date.toString(), '$year-09-28 18:31:32.000');
      expect(text, '打卡，下班，');
    });
  });
  group('parse diary', () {
    final diarySplit = DiarySplit();
    test('append', () async {
      final content = '''

00:44:57 睡觉，

23:32:57 上床，

12:38:17 麻辣烫，三荤三素，17元，
test

08:14:18 起床，

00:54:08 睡觉，

18:41:15 公交车站边上多了一堆铁栏杆，

18:31:32 打卡，下班，

9月28日
''';
      diarySplit.append(content);
      expect(diarySplit.contentText, '''9月28日
18:31:32 打卡，下班，
18:41:15 公交车站边上多了一堆铁栏杆，
00:54:08 睡觉，
08:14:18 起床，
12:38:17 麻辣烫，三荤三素，17元，
test
23:32:57 上床，
00:44:57 睡觉，''');
    });
    test('first day', () async {
      final diary = await diarySplit.popDiary();
      expect(diary.start.toString(), '$year-09-28 00:00:00.000');
      expect(diary.end.toString(), '$year-09-29 00:54:08.000');
      expect(diary.content, '''9月28日
18:31:32 打卡，下班，
18:41:15 公交车站边上多了一堆铁栏杆，
00:54:08 睡觉，''');
    });
    test('second day', () async {
      final diary = await diarySplit.popDiary();
      expect(diary.start.toString(), '$year-09-29 08:14:18.000');
      expect(diary.end.toString(), '$year-09-30 00:44:57.000');
      expect(diary.content, '''08:14:18 起床，
12:38:17 麻辣烫，三荤三素，17元，
test
23:32:57 上床，
00:44:57 睡觉，''');
    });
  });
}
