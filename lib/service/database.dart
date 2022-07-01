import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_todo_app/models/todo_models.dart';

class Database {
  final FirebaseFirestore firestore;
  Database({required this.firestore});

  Stream<List<Todo>> streamTodos({required String uid}) {
    try {
      return firestore
          .collection('todos')
          .doc(uid)
          .collection('todos')
          .where('done', isEqualTo: false)
          .snapshots()
          .map((e) {
        final List<Todo> retVal = <Todo>[];
        for (final DocumentSnapshot snapshot in e.docs) {
          retVal.add(Todo.fromDocumentSnapshot(documentSnapshot: snapshot));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodo({required String content, required String uid}) async {
    try {
      firestore.collection('todos').doc(uid).collection('todos').add(
        {
          'content': content,
          'done': false,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTodo({required String todoId, required String uid}) async {
    try {
      firestore
          .collection('todos')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .update(
        {
          "done": true,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
