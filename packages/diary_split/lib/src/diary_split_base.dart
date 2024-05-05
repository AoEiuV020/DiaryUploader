import 'package:diary_split/diary_split.dart';

/// Checks if you are awesome. Spoiler: you are.
abstract class DiarySplit {
  void setStartTime(int startTime);
  void append(String diaryDraft);
  Diary popDiary();
}
