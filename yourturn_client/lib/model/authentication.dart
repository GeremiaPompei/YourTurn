import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async =>
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

  Future<UserCredential> logInEmailPassword(String email, String password) async =>
      await _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> logInToken(String token) async =>
      await _auth.signInWithCustomToken(token);

  Future<void> logOut() async =>
      await _auth.signOut();
}
