import '../diary_split.dart';
import 'diary_split_impl.dart';

/// Checks if you are awesome. Spoiler: you are.
abstract class DiarySplit {
  factory DiarySplit() => DiarySplitImpl();
  abstract String content;
  set startTime(DateTime? value);
  void append(String diaryDraft);
  Diary popDiary();
}
