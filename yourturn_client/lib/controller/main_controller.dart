import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/rest_functions.dart';
import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/model/user.dart' as myuser;

class MainController {
  myuser.User _user;
  bool _authenticate;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RestFunctions _rest = new RestFunctions();

  MainController() {
    this._authenticate = false;
  }

  Future<bool> testConnection() async {
    var res = await _rest.test();
    if (res == 200)
      return true;
    else
      return false;
  }

  Future<dynamic> signIn(String nome, String cognome, String annonascita,
      String sesso, String email, String telefono, String password) async {
    await testConnection();
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
    await testConnection();
    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    var response = await _rest.getUser(credential.user.uid);
    this._user = await myuser.User.fromJsonAdmin(json.decode(response));
    this._authenticate = true;
    return response;
  }

  Future<dynamic> update() async {
    await testConnection();
    var response = await _rest.getUser(this._user.uid);
    this._user = await myuser.User.fromJsonAdmin(json.decode(response));
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
    await update();
    return response;
  }

  Future<dynamic> enqueueToOther(Queue queue, myuser.User user) async {
    Ticket ticket = Ticket(queue, user);
    var res = await _rest.enqueue(ticket);
    return res;
  }

  Future<bool> checkQueue(String id) async {
    Queue queue = await getQueue(id);
    if (queue == null || queue.isClosed)
      return false;
    else
      return true;
  }

  Future<Queue> getQueue(String id) async {
    if (id == '') return null;
    dynamic res = await _rest.getQueue(id);
    if (res.toString() == '') return null;
    Map<String, dynamic> queue = json.decode(res);
    return await Queue.fromJson(queue, _user);
  }

  Future<dynamic> next() async {
    return await _rest.next(last.id);
  }

  Future<dynamic> closeQueue() async {
    last.close();
    await _rest.createQueue(last);
    return await update();
  }

  Future<dynamic> closeTicket(Ticket ticket) async{
    ticket.close();
    return await _rest.setTicket(ticket);
  }

  Queue get last => _user.myQueues.last;

  myuser.User get user => _user;

  List<Queue> get myQueues => _user.myQueues;

  List<Ticket> get tickets => _user.tickets;

  bool get authenticate => _authenticate;
}
