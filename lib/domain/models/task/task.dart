import 'package:flutter/foundation.dart';

@immutable
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.isDone,
    required this.createdAt,
  });

  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          isDone == other.isDone &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(id, title, isDone, createdAt);
}
