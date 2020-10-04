import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final _facebookLogin = FacebookLogin();

  Future<UserCredential> signIn(String email, String password) async =>
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

  Future<UserCredential> logInEmailPassword(
          String email, String password) async =>
      await _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signInWithCredential(AuthCredential credential) async =>
      await _auth.signInWithCredential(credential);

  Future<void> logOut() async => await _auth.signOut();

  Future<void> removeUser(UserCredential userCredential) async =>
      await userCredential.user.delete();

  Future<GoogleSignInAccount> googleSignIn() async{
    return await _googleSignIn.signIn();
  }

  Future<FacebookLoginResult> facebookSignIn() async {
    return (await _facebookLogin.logIn(['email']));
  }
}
