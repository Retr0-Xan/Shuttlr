// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;


Stream<User?> get user{
  return _auth.authStateChanges();
}

//sign in anonymously
Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? Firebaseuser = userCredential.user;
      return Firebaseuser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign out
Future signOut() async {
  try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email
  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? Firebaseuser = userCredential.user;
      return Firebaseuser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}