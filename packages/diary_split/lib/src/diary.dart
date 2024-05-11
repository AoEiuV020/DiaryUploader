// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Diary {
  final String title;
  final String content;
  final DateTime start;
  final DateTime end;

  Diary(
    this.title,
    this.content,
    this.start,
    this.end,
  );

  Diary copyWith({
    String? title,
    String? content,
    DateTime? start,
    DateTime? end,
  }) {
    return Diary(
      title ?? this.title,
      content ?? this.content,
      start ?? this.start,
      end ?? this.end,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'content': content,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
    };
  }

  factory Diary.fromMap(Map<String, dynamic> map) {
    return Diary(
      map['title'] as String,
      map['content'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['start'] as int),
      DateTime.fromMillisecondsSinceEpoch(map['end'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Diary.fromJson(String source) =>
      Diary.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Diary(title: $title, content: $content, start: $start, end: $end)';
  }

  @override
  bool operator ==(covariant Diary other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.content == content &&
      other.start == start &&
      other.end == end;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      content.hashCode ^
      start.hashCode ^
      end.hashCode;
  }
}
