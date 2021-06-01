import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled3/model/chatUserModel.dart';
import '../function/authentication.dart';

import 'conversationList.dart';
import 'login.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

bool _isSigningIn = true;

class _MainScreenState extends State<MainScreen> {
  final _auth = FirebaseAuth.instance;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Signing out "),
          actions: <Widget>[
            TextButton(
              child: new Text("Yes"),
              onPressed: () {
                setState(() {
                  _isSigningIn = false;
                  Authentication.signOut(context: context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false,
                  );

                });
              },
            ),
            TextButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_auth.currentUser.displayName),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _showDialog();
                },
                child: Icon(Icons.more_vert),
              )),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('listUser').where('id' ,isNotEqualTo: _auth.currentUser.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot)  {

           if (streamSnapshot.hasError)
             return Text('Error: ${streamSnapshot.error}');

           switch (streamSnapshot.connectionState) {
             case ConnectionState.none: return Text('Select lot');
             case ConnectionState.waiting: return Text('Awaiting bids...');
             case ConnectionState.active: {final listuser = streamSnapshot.data.docs.map((e) => ChatUsers.fromJson(e.data())).toList();
             return ListView.builder(
                 itemCount: listuser.length,
                 shrinkWrap: true,
                 padding: EdgeInsets.only(top: 16),
                 itemBuilder: (context, index) {

                   return ConversationList   (
                       chatUsers: listuser[index]);
                 });}
             case ConnectionState.done: return Text('done');
           }
           return null;
        },
      ),
    );
  }
}
