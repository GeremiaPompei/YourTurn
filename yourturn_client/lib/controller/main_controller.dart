import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/rest_functions.dart';
import 'package:yourturn_client/model/user.dart' as myuser;

class MainController {
  myuser.User _user;
  bool _authenticate;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RestFunctions _rest = new RestFunctions();

  MainController() {
    this._authenticate = false;
  }

  Future<dynamic> signIn(String nome, String cognome, String annonascita,
      String sesso, String email, String telefono, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    myuser.User user = new myuser.User(
        credential.user.uid,
        await credential.user.getIdToken(),
        nome,
        cognome,
        annonascita,
        sesso,
        email,
        telefono);
    var response = await _rest.createUser(user);
    this._user = user;
    this._authenticate = true;
    return response;
  }

  Future<dynamic> logIn(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    var response = await _rest.getUser(credential.user.uid);
    this._user = new myuser.User.fromJson(json.decode(response));
    this._authenticate = true;
    return response;
  }

  Future<dynamic> logOut() async {
    var out = await _auth.signOut();
    _authenticate = false;
    return out;
  }

  Future<dynamic> createQueue(String id, String luogo) async {
    Queue queue = new Queue(id, luogo, _user);
    var response = await _rest.createQueue(queue);
    myQueues.add(queue);
    return response;
  }

  void closeQueue() => myQueues.last.close();

  void next() {
    if (!myQueues.last.isClosed) myQueues.last.next();
  }

  Future<dynamic> enqueueToOther(Queue queue) async {
    Map<String, dynamic> enqueue = {'uid': _user.uid, 'id': queue.id};
    _user.otherQueues.add(queue);
    return await _rest.enqueue(enqueue);
  }

  Future<bool> checkQueue(String id) async {
    if (id == '') return false;
    var res = await _rest.getQueue(id);
    if (res.toString() == '')
      return false;
    else
      return true;
  }

  Future<Queue> getQueue(String id) async {
    if (id == '') return null;
    dynamic res = await _rest.getQueue(id);
    if (res.toString() == '') return null;
    Map<String, dynamic> queue = json.decode(res);
    return Queue.fromJson(queue, _user);
  }

  myuser.User get user => _user;

  myuser.User get first => myQueues.last.getFirst();

  List<Queue> get myQueues => _user.myQueues;

  List<Queue> get otherQueues => _user.otherQueues;

  bool get authenticate => _authenticate;
}
