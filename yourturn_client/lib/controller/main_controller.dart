import 'package:firebase_auth/firebase_auth.dart';
import 'package:yourturn_client/model/cache.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/rest_functions.dart';
import 'package:yourturn_client/model/user.dart' as user;

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
    var result =
        _auth.createUserWithEmailAndPassword(email: email, password: password);
    result.then((value) => print(value.credential.toString()));
    var res =
        await RestFunctions.signIn(nome, cognome, eta, sesso, email, telefono);
    this._authenticate = true;
    return res;
  }

  Future<dynamic> logIn(String email, String password) {
    var result =
    _auth.signInWithEmailAndPassword(email: email, password: password);
    result.then((value) => print(value.credential.toString()));
    return result;
  }

  void createQueue(String id, String luogo) =>
      myQueues.add(new Queue(id, luogo, admin));

  void enqueue(user.User user) => myQueues.last.enqueue(user);

  void dequeue(user.User user) => myQueues.last.dequeue(user);

  void next() => myQueues.last.next();

  user.User get first => myQueues.last.getFirst();

  List<Queue> get myQueues => _cache.myQueues;

  List<Queue> get otherQueues => _cache.otherQueues;

  bool get authenticate => _authenticate;

  user.User get admin => this._cache.admin;

  set admin(user.User value) {
    this._cache.admin = value;
  }
}
