import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
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
  Authentication _authentication;
  Rest _rest;
  Messaging _messaging;
  StoreManager _storeManager;
  Cache _cache;

  MainController() {
    this._authentication = new Authentication();
    this._rest = new Rest();
    this._messaging = new Messaging();
    this._storeManager = new StoreManager();
    this._cache = new Cache();
  }

  Future<bool> testConnection() async {
    var res = await _rest.test();
    if (res == 200)
      return true;
    else
      return false;
  }

  Future<Map> googleCedential() async {
    await testConnection();
    GoogleSignInAccount account = await this._authentication.googleSignIn();
    GoogleSignInAuthentication authentication = await account.authentication;
    GoogleAuthCredential googleAuth = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    return {'credential': googleAuth, 'account': account};
  }

  Future<myuser.User> googleSignIn(
      String annonascita, String sesso, String telefono) async {
    Map authCredential = await googleCedential();
    UserCredential userCredential = await this
        ._authentication
        .signInWithCredential(authCredential['credential']);
    String name = authCredential['account']
        .displayName
        .substring(0, authCredential['account'].displayName.indexOf(' '));
    await _signIn(
        userCredential.user.uid,
        name,
        authCredential['account'].displayName.replaceAll(name, ''),
        annonascita,
        sesso,
        authCredential['account'].email,
        telefono);
    return _user;
  }

  Future<myuser.User> facebookSignIn(
      String annonascita, String sesso, String telefono) async {
    FacebookLoginResult result = await this._authentication.facebookSignIn();
    final token = result.accessToken.token;
    final graphResponse = await Client().get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = json.decode(graphResponse.body);
    final facebookAuthCred = FacebookAuthProvider.getCredential(token);
    UserCredential userCredential =
        await this._authentication.signInWithCredential(facebookAuthCred);
    await _signIn(userCredential.user.uid, profile['first_name'],
        profile['last_name'], annonascita, sesso, profile['email'], telefono);
    return _user;
  }

  Future<myuser.User> signInEmailPassword(
      String nome,
      String cognome,
      String annonascita,
      String sesso,
      String email,
      String telefono,
      String password) async {
    await testConnection();
    UserCredential userCredential =
        await this._authentication.signIn(email, password);
    await _signIn(userCredential.user.uid, nome, cognome, annonascita, sesso,
        email, telefono);
    return _user;
  }

  Future<void> _signIn(String uid, String nome, String cognome,
      String annonascita, String sesso, String email, String telefono) async {
    var response = await _rest.createUser(uid, _messaging.token, nome, cognome,
        annonascita, sesso, email, telefono);
    this._user = myuser.User.fromJsonAdmin(json.decode(response), _cache);
    _saveUid();
    _saveLocal(response);
  }

  Future<void> _logIn(UserCredential userCredential) async {
    var response = await _rest.getUser(userCredential.user.uid);

    this._user = myuser.User.fromJsonAdmin(json.decode(response), _cache);
    if (!this._user.tokenid.contains(_messaging.token)) {
      this._user.tokenid.add(_messaging.token);
      _rest.addTokenidUser(_user.uid, _messaging.token);
    }
    _saveUid();
    _saveLocal(response);
  }

  Future<myuser.User> googleLogIn() async {
    Map authCredential = await googleCedential();
    UserCredential userCredential = await this
        ._authentication
        .signInWithCredential(authCredential['credential']);
    await _logIn(userCredential);
    return this._user;
  }

  Future<myuser.User> facebookLogIn() async {
    FacebookLoginResult result = await this._authentication.facebookSignIn();
    final token = result.accessToken.token;
    final facebookAuthCred = FacebookAuthProvider.getCredential(token);
    UserCredential userCredential =
        await this._authentication.signInWithCredential(facebookAuthCred);
    await _logIn(userCredential);
    return this._user;
  }

  Future<myuser.User> logInEmailPassword(String email, String password) async {
    await testConnection();
    UserCredential userCredential =
        await this._authentication.logInEmailPassword(email, password);
    await _logIn(userCredential);
    return this._user;
  }

  Future<myuser.User> update() async {
    await testConnection();
    _cache = new Cache();
    var response = await _rest.getUser(this._user.uid);
    this._user = myuser.User.fromJsonAdmin(json.decode(response), _cache);
    _saveLocal(response);
    return this._user;
  }

  Future<void> logOut() async {
    try {
      await this._authentication.logOut();
      _user.tokenid.remove(_messaging.token);
      await _rest.removeTokenidUser(_user.uid, _messaging.token);
    } catch (e) {} finally {
      (await _storeManager.localFile('uid.txt')).delete();
      (await _storeManager.localFile('local.json')).delete();
    }
  }

  Future<void> removeUser(String email, String password) async {
    await testConnection();
    UserCredential userCredential =
        await this._authentication.logInEmailPassword(email, password);
    await this._rest.removeUser(this._user.uid);
    await this._authentication.removeUser(userCredential);
    (await _storeManager.localFile('uid.txt')).delete();
    (await _storeManager.localFile('local.json')).delete();
  }

  Future<Queue> createQueue(String id, String luogo) async {
    this._user.queue = Queue.fromJson(
        json.decode(await _rest.createQueue(id, luogo, _user.uid)), _cache);
    return this._user.queue;
  }

  Future<Queue> getQueue(String id) async {
    if (id == '') return null;
    dynamic res = await _rest.getQueue(id);
    if (res.toString() == '') return null;
    Map<String, dynamic> queue = json.decode(res);
    return Queue.fromJson(queue, _cache);
  }

  Future<Ticket> enqueueToOther(Queue queue, myuser.User user) async {
    Map<String, dynamic> map =
        json.decode(await _rest.enqueue(queue.id, user.uid));
    return Ticket.fromJson(map, _cache);
  }

  Future<Queue> next(Queue queue) async {
    Map<String, dynamic> map = json.decode(await _rest.next(queue.id));
    return Queue.fromJson(map, _cache);
  }

  Future<void> closeQueue(Queue queue) async {
    await _rest.closeQueue(queue.id);
  }

  void configMessaging(context) {
    this._messaging.config(context);
  }

  Future<myuser.User> load() async {
    try {
      await _loadUid();
    } catch (e) {
      await _loadLocal();
    }
    return this._user;
  }

  Future<void> _saveUid() async {
    await _storeManager.store(_user.uid, 'uid.txt');
  }

  Future<void> _loadUid() async {
    this._user = myuser.User.fromJsonAdmin(
        json.decode(await _rest.getUser(await _storeManager.load('uid.txt'))),
        _cache);
  }

  Future<void> _saveLocal(response) async {
    try {
      await this._storeManager.store(response, 'local.json');
    } catch (e) {}
  }

  Future<void> _loadLocal() async {
    if ((await this._storeManager.localFile('local.json')) != null) {
      var response = await this._storeManager.load('local.json');
      this._user = myuser.User.fromJsonAdmin(json.decode(response), _cache);
    }
  }

  Map<String, dynamic> get messages => this._messaging.messages;

  myuser.User get user => _user;

  Queue get queue => _user.queue;

  List<Ticket> get tickets => _user.tickets;
}
