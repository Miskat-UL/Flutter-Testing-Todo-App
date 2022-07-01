import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../service/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.auth, required this.firestore});
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Username or Email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: "password"),
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.blueGrey,
              child: TextButton(
                onPressed: () async {
                  final String retVal = await Auth(auth: widget.auth).signIn(
                      email: _emailController.text,
                      password: _passwordController.text);
                  if (retVal == "success") {
                    _emailController.clear();
                    _passwordController.clear();
                  } else {
                    SnackBar(
                      content: Text(retVal),
                    );
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () async {
                  final String retVal = await Auth(auth: widget.auth)
                      .createAccount(
                          email: _emailController.text,
                          password: _passwordController.text);
                  if (retVal == "success") {
                    _emailController.clear();
                    _passwordController.clear();
                  } else {
                    SnackBar(
                      content: Text(retVal),
                    );
                  }
                },
                child: const Text("creat account"))
          ]),
        ),
      ),
    );
  }
}
