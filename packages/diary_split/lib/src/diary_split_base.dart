import '../diary_split.dart';
import 'diary_split_impl.dart';

abstract class DiarySplit {
  factory DiarySplit() => DiarySplitImpl();
  abstract String content;
  set startTime(DateTime? value);
  void append(String diaryDraft);
  Future<Diary> popDiary();
}
