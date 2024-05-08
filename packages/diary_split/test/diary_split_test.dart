import 'package:diary_split/src/date_time_parser.dart';
import 'package:test/test.dart';

void main() {
  group('date format test', () {
    test('start time parse', () {
      final parser = DateTimeParser();
      final (date, text) = parser.parse('9月28日');
      expect(date.toString(), '${DateTime.now().year}-09-28 00:00:00.000');
      expect(text, '');
    });
  });
}
