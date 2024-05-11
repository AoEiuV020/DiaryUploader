// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GoogleCalendar {
  final String id;
  final String name;

  GoogleCalendar(
    this.id,
    this.name,
  );

  GoogleCalendar copyWith({
    String? id,
    String? name,
  }) {
    return GoogleCalendar(
      id ?? this.id,
      name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory GoogleCalendar.fromMap(Map<String, dynamic> map) {
    return GoogleCalendar(
      map['id'] as String,
      map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GoogleCalendar.fromJson(String source) => GoogleCalendar.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GoogleCalendar(id: $id, name: $name)';

  @override
  bool operator ==(covariant GoogleCalendar other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
