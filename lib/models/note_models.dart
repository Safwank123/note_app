import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final int? color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.color,
  });

  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      title: data['title'] ?? 'Untitled',
      content: data['content'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      color: data['color'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': Timestamp.fromDate(date),
      if (color != null) 'color': color,
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    int? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      color: color ?? this.color,
    );
  }
}