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
    test('time text parse', () {
      final (date, text) = parser.parse('18:31:32 打卡，下班，');
      expect(date.toString(), '$year-09-28 18:31:32.000');
      expect(text, '打卡，下班，');
    });
    test('time without seconds text parse', () {
      final (date, text) = parser.parse('15:11 打个喷嚏，');
      expect(date.toString(), '$year-09-28 15:11:00.000');
      expect(text, '打个喷嚏，');
    });
  });
  group('parse diary', () {
    final diarySplit = DiarySplit();
    test('two day', () async {
      diarySplit.append('''

00:44:57 睡觉，

23:32:57 上床，

12:38:17 麻辣烫，三荤三素，17元，

08:14:18 起床，

00:54:08 睡觉，

18:41:15 公交车站边上多了一堆铁栏杆，

18:31:32 打卡，下班，

9月28日
''');
      final diary = await diarySplit.popDiary();
      print(diary.content);
      expect(diary.start.toString(), '$year-09-28 00:00:00.000');
      expect(diary.end.toString(), '$year-09-29 00:54:08.000');
    });
  });
}
