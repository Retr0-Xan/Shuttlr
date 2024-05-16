// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //this is a stream of users which will help us track user auth changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  //this is a stream of users(which are drivers) which will help us track user auth changes
  Stream<User?> get driver {
    return _auth.authStateChanges();
  }

//sign in anonymously
  Future signInAnon(String? username) async {
    try {
      UserCredential? userCredential = await _auth.signInAnonymously();
      User? Firebaseuser = userCredential.user;
      await Firebaseuser?.updateDisplayName(username);
      await Firebaseuser?.reload();
      Firebaseuser = FirebaseAuth.instance.currentUser;
      print(Firebaseuser);
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
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? Firebaseuser = userCredential.user;
      return [Firebaseuser, Firebaseuser?.uid];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
