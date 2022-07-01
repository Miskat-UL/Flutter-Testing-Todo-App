import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_app/service/auth.dart';
import 'package:my_todo_app/service/database.dart';

import '../models/todo_models.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.auth, required this.firestore});
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _todosc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              key: const ValueKey("SignOut"),
              onPressed: () {
                Auth(auth: widget.auth).signOut();
              },
              icon: const Icon(Icons.exit_to_app))
        ],
        title: const Text("My ToDo!"),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: TextField(
                    controller: _todosc,
                    decoration: const InputDecoration(
                      hintText: "Add To Do",
                    ),
                  ),
                ),
                Expanded(
                    child: IconButton(
                  onPressed: () {
                    if (_todosc.text != "") {
                      setState(() {
                        Database(firestore: widget.firestore).addTodo(
                            content: _todosc.text,
                            uid: widget.auth.currentUser!.uid);
                        _todosc.clear();
                      });
                    }
                  },
                  icon: const Icon(Icons.add),
                ))
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text("Your To dos here"),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: StreamBuilder(
                stream: Database(firestore: widget.firestore)
                    .streamTodos(uid: widget.auth.currentUser!.uid),
                builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("you have no todo !"),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(snapshot.data![index].content),
                              ),
                              Checkbox(
                                value: snapshot.data![index].done,
                                onChanged: (_) {
                                  Database(firestore: widget.firestore)
                                      .deleteTodo(
                                    todoId: snapshot.data![index].todoId,
                                    uid: widget.auth.currentUser!.uid,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
