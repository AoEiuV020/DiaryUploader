/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

export 'src/diary_split_base.dart';

class Diary {
  final String content;
  final DateTime start;
  final DateTime end;

  Diary(this.content, this.start, this.end);
}
