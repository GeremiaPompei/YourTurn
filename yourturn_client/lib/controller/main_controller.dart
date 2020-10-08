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
  String _blacklistChars;

  MainController() {
    this._authentication = new Authentication();
    this._rest = new Rest();
    this._messaging = new Messaging();
    this._storeManager = new StoreManager();
    this._cache = new Cache();
    this._blacklistChars = '[offline]';
    _rest.getBlackListChars().then((value) {
      this._blacklistChars = value;
      _saveBlackList();
    });
  }

  String get blacklistChars => _blacklistChars;

  Future<bool> _testConnection() async {
    return await _rest.test();
  }

  Future<Map> googleCedential() async {
    await _testConnection();
    GoogleSignInAccount account = await this._authentication.googleSignIn();
    GoogleSignInAuthentication authentication = await account.authentication;
    GoogleAuthCredential googleAuth = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    return {'credential': googleAuth, 'account': account};
  }

  Future<void> _signIn(
      UserCredential userCredential,
      String nome,
      String cognome,
      String annonascita,
      String sesso,
      String email,
      String telefono) async {
    var response = await _rest.createUser(userCredential.user.uid,
        _messaging.token, nome, cognome, annonascita, sesso, email, telefono);
    if (response.isEmpty) {
      await this._authentication.removeUser(userCredential);
      throw new Exception();
    }
    this._user = myuser.User.fromJsonAdmin(json.decode(response), _cache);
    _saveUid();
    _saveLocal(response);
  }

  Future<void> _logIn(UserCredential userCredential) async {
    var response = await _rest.getUser(userCredential.user.uid);
    if (response.isEmpty) throw new Exception();
    this._user = myuser.User.fromJsonAdmin(json.decode(response), _cache);
    if (!this._user.tokenid.contains(_messaging.token)) {
      this._user.tokenid.add(_messaging.token);
      _rest.addTokenidUser(_user.uid, _messaging.token);
    }
    _saveUid();
    _saveLocal(response);
  }

  Future<void> _removeUser(UserCredential userCredential) async {
    var response = await this._rest.removeUser(this._user.uid);
    if (response.isEmpty) throw new Exception();
    await this._authentication.removeUser(userCredential);
    _removeFiles();
  }

  Future<myuser.User> signInGoogle(
      String annonascita, String sesso, String telefono) async {
    Map authCredential = await googleCedential();
    UserCredential userCredential = await this
        ._authentication
        .signInWithCredential(authCredential['credential']);
    String name = authCredential['account']
        .displayName
        .substring(0, authCredential['account'].displayName.indexOf(' '));
    await _signIn(
        userCredential,
        name,
        authCredential['account'].displayName.replaceAll(name, ''),
        annonascita,
        sesso,
        authCredential['account'].email,
        telefono);
    return _user;
  }

  Future<myuser.User> signInFacebook(
      String annonascita, String sesso, String telefono) async {
    FacebookLoginResult result = await this._authentication.facebookSignIn();
    final token = result.accessToken.token;
    final graphResponse = await Client().get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = json.decode(graphResponse.body);
    final facebookAuthCred = FacebookAuthProvider.getCredential(token);
    UserCredential userCredential =
        await this._authentication.signInWithCredential(facebookAuthCred);
    await _signIn(userCredential, profile['first_name'], profile['last_name'],
        annonascita, sesso, profile['email'], telefono);
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
    await _testConnection();
    UserCredential userCredential =
        await this._authentication.signIn(email, password);
    await _signIn(
        userCredential, nome, cognome, annonascita, sesso, email, telefono);
    return _user;
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
    final facebookAuthCred = FacebookAuthProvider.credential(token);
    UserCredential userCredential =
        await this._authentication.signInWithCredential(facebookAuthCred);
    await _logIn(userCredential);
    return this._user;
  }

  Future<myuser.User> logInEmailPassword(String email, String password) async {
    await _testConnection();
    UserCredential userCredential =
        await this._authentication.logInEmailPassword(email, password);
    await _logIn(userCredential);
    return this._user;
  }

  Future<myuser.User> update() async {
    await _testConnection();
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
      _removeFiles();
    }
  }

  Future<void> _removeFiles() async {
    var uidTxt = await _storeManager.localFile('uid.txt');
    if (uidTxt != null) uidTxt.delete();
    var localTxt = await _storeManager.localFile('local.json');
    if (localTxt != null) localTxt.delete();
  }

  Future<void> removeUserFacebook() async {
    await _testConnection();
    FacebookLoginResult result = await this._authentication.facebookSignIn();
    final token = result.accessToken.token;
    final facebookAuthCred = FacebookAuthProvider.credential(token);
    UserCredential userCredential =
        await this._authentication.signInWithCredential(facebookAuthCred);
    _removeUser(userCredential);
  }

  Future<void> removeUserGoogle() async {
    await _testConnection();
    Map authCredential = await googleCedential();
    UserCredential userCredential = await this
        ._authentication
        .signInWithCredential(authCredential['credential']);
    _removeUser(userCredential);
  }

  Future<void> removeUserEmailPassword(String email, String password) async {
    await _testConnection();
    UserCredential userCredential =
        await this._authentication.logInEmailPassword(email, password);
    _removeUser(userCredential);
  }

  Future<Queue> createQueue(String id, String luogo) async {
    var queue = await _rest.createQueue(id, luogo, _user.uid);
    if (queue.isEmpty) throw new Exception();
    this._user.queue = Queue.fromJson(json.decode(queue), _cache);
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
    await update();
  }

  void configMessaging(context) {
    this._messaging.config(context);
  }

  Future<myuser.User> load() async {
    try {
      await _loadBlackList();
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

  Future<void> _saveBlackList() async {
    try {
      await this._storeManager.store(this._blacklistChars, 'blacklist.txt');
    } catch (e) {}
  }

  Future<void> _loadBlackList() async {
    if ((await this._storeManager.localFile('blacklist.txt')) != null) {
      this._blacklistChars = await this._storeManager.load('blacklist.txt');
    }
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
