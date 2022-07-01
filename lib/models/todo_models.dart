import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  late String todoId;
  late String content;
  late bool done;

  Todo( this.content, this.done, this.todoId);

  Todo.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    todoId = documentSnapshot.id;
    content = documentSnapshot['content'] as String;
    done = documentSnapshot['done'] as bool;
  }
  
}
