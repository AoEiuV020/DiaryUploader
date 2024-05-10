import '../diary_split.dart';
import 'diary_split_impl.dart';

abstract class DiarySplit {
  factory DiarySplit() => DiarySplitImpl();
  List<List<String>> get content;
  String get contentText;
  set startTime(DateTime? value);
  void append(String diaryDraft);
  Future<Diary> popDiary();
}
