import '../diary_split.dart';

class DiarySplitImpl implements DiarySplit {
  @override
  String content = '';
  @override
  DateTime? startTime;
  @override
  void append(String diaryDraft) {
    content += diaryDraft;
  }

  @override
  Diary popDiary() {
    // TODO: implement popDiary
    throw UnimplementedError();
  }
}
