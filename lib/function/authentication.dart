import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Authentication {
  static Future<User> signInWithGoogle({ BuildContext context}) async {
    User user;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;




      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  static updateInfo() {
    final _firestore = FirebaseFirestore.instance;
    FirebaseFirestore.instance
        .collection('listUser').where('id', isEqualTo: auth.currentUser.uid)
        .get()
        .then((QuerySnapshot) {
      if (QuerySnapshot.docs.length !=0) {
        print('Account exists on the database');
      }
      else
      {
        _firestore.collection('listUser').add({
          'id': auth.currentUser.uid,
          'name': auth.currentUser.displayName,
          'mail': auth.currentUser.email,
          'imageURl': auth.currentUser.photoURL
        });
      }
    });


  }

  static SnackBar customSnackBar({ String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<void> signOut({ BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
