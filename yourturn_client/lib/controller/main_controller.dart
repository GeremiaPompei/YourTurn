import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:yourturn_client/model/cache.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/rest_functions.dart';
import 'package:yourturn_client/model/user.dart' as myuser;

class MainController {
  Cache _cache;
  bool _authenticate;
  FirebaseAuth _auth = FirebaseAuth.instance;

  MainController() {
    this._authenticate = false;
    this._cache = new Cache();
  }

  Future<dynamic> signIn(String nome, String cognome, String eta, String sesso,
      String email, String telefono, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    myuser.User user = new myuser.User(
        credential.user.uid, nome, cognome, eta, sesso, email, telefono);
    var response = await RestFunctions.signIn(user);
    this.admin = user;
    this._authenticate = true;
    return response;
  }

  Future<dynamic> logIn(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    var response = await RestFunctions.logIn(credential.user.uid);
    this.admin = new myuser.User.fromJson(json.decode(response));
    this._authenticate = true;
    return response;
  }

  void createQueue(String id, String luogo) =>
      myQueues.add(new Queue(id, luogo, admin));

  void enqueue(myuser.User user) => myQueues.last.enqueue(user);

  void dequeue(myuser.User user) => myQueues.last.dequeue(user);

  void next() => myQueues.last.next();

  myuser.User get first => myQueues.last.getFirst();

  List<Queue> get myQueues => _cache.myQueues;

  List<Queue> get otherQueues => _cache.otherQueues;

  bool get authenticate => _authenticate;

  myuser.User get admin => this._cache.admin;

  set admin(myuser.User value) {
    this._cache.admin = value;
  }
}
