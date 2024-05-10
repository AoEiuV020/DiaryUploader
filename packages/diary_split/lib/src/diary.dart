// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Diary {
  final String content;
  final DateTime start;
  final DateTime end;

  Diary(
    this.content,
    this.start,
    this.end,
  );

  Diary copyWith({
    String? content,
    DateTime? start,
    DateTime? end,
  }) {
    return Diary(
      content ?? this.content,
      start ?? this.start,
      end ?? this.end,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
    };
  }

  factory Diary.fromMap(Map<String, dynamic> map) {
    return Diary(
      map['content'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['start'] as int),
      DateTime.fromMillisecondsSinceEpoch(map['end'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Diary.fromJson(String source) =>
      Diary.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Diary(content: $content, start: $start, end: $end)';

  @override
  bool operator ==(covariant Diary other) {
    if (identical(this, other)) return true;

    return other.content == content && other.start == start && other.end == end;
  }

  @override
  int get hashCode => content.hashCode ^ start.hashCode ^ end.hashCode;
}
