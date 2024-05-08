import 'package:diary_split/src/date_time_parser.dart';
import 'package:test/test.dart';

void main() {
  group('date format test', () {
    final parser = DateTimeParser();
    test('start time parse', () {
      final (date, text) = parser.parse('9月28日');
      expect(date.toString(), '${DateTime.now().year}-09-28 00:00:00.000');
      expect(text, '');
    });
    test('time text parse', () {
      final (date, text) = parser.parse('18:31:32 打卡，下班，');
      expect(date.toString(), '${DateTime.now().year}-09-28 18:31:32.000');
      expect(text, '打卡，下班，');
    });
    test('time without seconds text parse', () {
      final (date, text) = parser.parse('15:11 打个喷嚏，');
      expect(date.toString(), '${DateTime.now().year}-09-28 15:11:00.000');
      expect(text, '打个喷嚏，');
    });
  });
}
