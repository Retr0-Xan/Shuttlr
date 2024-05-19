// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //this is a stream of users which will help us track user auth changes.
  //we use this stream to route the user to the appropriate page after login
  //we use the delayStreamTransformer to delay the stream by 1 second to ensure that the stream is not empty
  //this is because for anonymous sign ins, the displayName parameter is null right after signing in
  //by delaying the stream, we give the user object a chance to update the displayName to be able to be accessed in the home page

  Stream<User?> get user {
    return _auth
        .authStateChanges()
        .transform(delayStreamTransformer(Duration(seconds: 1)));
  }

  StreamTransformer<T, T> delayStreamTransformer<T>(Duration duration) {
    return StreamTransformer<T, T>.fromHandlers(
      handleData: (data, sink) {
        Timer(duration, () => sink.add(data));
      },
    );
  }

  //this is a stream of users(which are drivers) which will help us track user auth changes
  Stream<User?> get driver {
    return _auth.authStateChanges();
  }

//sign in anonymously
  Future<User?> signInAnon(String user_name) async {
    try {
      // updateName(user_name);
      UserCredential? userCredential = await _auth.signInAnonymously();
      User? Firebaseuser = userCredential.user;
      await Firebaseuser?.updateDisplayName(user_name);
      await Firebaseuser?.reload();
      Firebaseuser = FirebaseAuth.instance.currentUser;
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
