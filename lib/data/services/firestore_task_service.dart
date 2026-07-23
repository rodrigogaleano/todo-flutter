import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_flutter/data/services/task_service.dart';
import 'package:todo_flutter/domain/models/task/task.dart';

class FirestoreTaskService implements TaskService {
  FirestoreTaskService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<Task>> watchTasks(String userId) {
    return _tasks(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_toTask).toList());
  }

  @override
  Future<void> createTask(String userId, String title) {
    return _tasks(userId).add({
      'title': title,
      'isDone': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> setTaskDone(
    String userId,
    String taskId, {
    required bool isDone,
  }) {
    return _tasks(userId).doc(taskId).update({'isDone': isDone});
  }

  @override
  Future<void> deleteTask(String userId, String taskId) {
    return _tasks(userId).doc(taskId).delete();
  }

  CollectionReference<Map<String, dynamic>> _tasks(String userId) {
    return _firestore.collection('users').doc(userId).collection('tasks');
  }

  Task _toTask(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Task(
      id: doc.id,
      title: data['title'] as String? ?? '',
      isDone: data['isDone'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
