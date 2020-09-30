import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yourturn_client/model/authentication.dart';
import 'package:yourturn_client/model/cache.dart';
import 'package:yourturn_client/model/messaging.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/rest.dart';
import 'package:yourturn_client/model/storemanager.dart';
import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/model/user.dart' as myuser;

class MainController {
  myuser.User _user;
  bool _authenticate;
  Authentication _authentication;
  Rest _rest;
  Messaging _messaging;
  StoreManager _storeManager;
  Cache _cache;

  MainController() {
    this._authenticate = false;
    this._authentication = new Authentication();
    this._rest = new Rest();
    this._messaging = new Messaging();
    this._storeManager = new StoreManager();
    this._cache = new Cache();
  }

  List<Map<String, dynamic>> get messages => this._messaging.messages;

  Future<bool> testConnection() async {
    var res = await _rest.test();
    if (res == 200)
      return true;
    else
      return false;
  }

  Future<myuser.User> signIn(String nome, String cognome, String annonascita,
      String sesso, String email, String telefono, String password) async {
    await testConnection();
    UserCredential userCredential =
        await this._authentication.signIn(email, password);
    this._user = myuser.User.fromJsonAdmin(
        json.decode(await _rest.createUser(
            userCredential.user.uid,
            _messaging.token,
            nome,
            cognome,
            annonascita,
            sesso,
            email,
            telefono)),
        _cache);
    this._authenticate = true;
    saveToken();
    return _user;
  }

  Future<void> _logIn(UserCredential userCredential) async {
    var response = await _rest.getUser(userCredential.user.uid);
    this._user = myuser.User.fromJsonAdmin(json.decode(response), _cache);
    if (this._user.tokenid != _messaging.token) {
      this._user.tokenid = _messaging.token;
      _rest.setUser(this._user);
    }
    this._authenticate = true;
    saveToken();
  }

  Future<myuser.User> logInEmailPassword(String email, String password) async {
    await testConnection();
    UserCredential userCredential =
        await this._authentication.logInEmailPassword(email, password);
    await _logIn(userCredential);
    return this._user;
  }

  Future<myuser.User> _logInToken(String token) async {
    await testConnection();
    UserCredential userCredential =
        await this._authentication.logInToken(token);
    await _logIn(userCredential);
    return this._user;
  }

  Future<myuser.User> update() async {
    await testConnection();
    var response = await _rest.getUser(this._user.uid);
    this._user = myuser.User.fromJsonAdmin(json.decode(response), _cache);
    this._authenticate = true;
    return this._user;
  }

  Future<void> logOut() async {
    await this._authentication.logOut();
    _user.tokenid = null;
    await _rest.setUser(_user);
    _authenticate = false;
    (await _storeManager.localFile('uid.txt')).delete();
  }

  Future<Queue> createQueue(String id, String luogo) async {
    _user.myQueues.where((element) => !element.isClosed).forEach((element) {
      element.close();
      _rest.setQueue(element);
    });
    this._user.myQueues.add(Queue.fromJson(
        json.decode(await _rest.createQueue(id, luogo, _user.uid)), _cache));
    return this._user.myQueues.last;
  }

  Future<Ticket> enqueueToOther(Queue queue, myuser.User user) async {
    Map<String, dynamic> map =
        json.decode(await _rest.enqueue(queue.id, user.uid));
    return Ticket.fromJson(map, _cache);
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
    return Queue.fromJson(queue, _cache);
  }

  Future<void> next() async {
    await _rest.next(last.id);
  }

  Future<void> closeQueue(Queue queue) async {
    last.close();
    await _rest.setQueue(queue);
  }

  Future<void> closeTicket(Ticket ticket) async {
    ticket.close();
    await _rest.setTicket(ticket);
  }

  Queue get last => _user.myQueues.last;

  myuser.User get user => _user;

  List<Queue> get myQueues => _user.myQueues;

  List<Ticket> get tickets => _user.tickets;

  bool get authenticate => _authenticate;

  Future<void> saveToken() async {
    await _storeManager.store(_user.uid, 'uid.txt');
  }

  Future<void> loadToken() async {
    try {
      this._user = myuser.User.fromJsonAdmin(
          json.decode(await _rest.getUser(await _storeManager.load('uid.txt'))),
          _cache);
      this._authenticate = true;
    } catch (e) {}
  }
}
