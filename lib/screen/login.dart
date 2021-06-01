import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';


import '../function/authentication.dart';
import 'mainscreen.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
      ),
      body: Center(
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                minimumSize: Size(100, 50)),
            icon: Icon(Icons.badge),
            label: Text("Sign in with Google"),
            onPressed: () async {
              setState(() {
                _isSigningIn = true;

              });

              User user =
              await Authentication.signInWithGoogle(context: context);
              setState(() {
                _isSigningIn = false;
              });
              Authentication.updateInfo();

              if (user != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MainScreen(
                    ),
                  ),
                );
              }
            }
        ),
      ),
    );
  }
}


