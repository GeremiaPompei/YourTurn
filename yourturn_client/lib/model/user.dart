import 'dart:convert';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/rest_functions.dart';

class User {
  String _uid;
  String _tokenid;
  String _nome;
  String _cognome;
  String _anno_nascita;
  String _sesso;
  String _email;
  String _telefono;
  List<Queue> _myQueues;
  List<Queue> _otherQueues;

  User(this._uid, this._tokenid, this._nome, this._cognome, this._anno_nascita,
      this._sesso, this._email, this._telefono) {
    this._myQueues = [];
    this._otherQueues = [];
  }

  User.all(
      this._uid,
      this._tokenid,
      this._nome,
      this._cognome,
      this._anno_nascita,
      this._sesso,
      this._email,
      this._telefono,
      this._myQueues,
      this._otherQueues);

  static Future<User> fromJson(Map<String, dynamic> pjson) async {
    RestFunctions rest = new RestFunctions();
    String uid = pjson['uid'];
    String nome = pjson['nome'];
    String cognome = pjson['cognome'];
    String annonascita = pjson['annonascita'];
    String sesso = pjson['sesso'];
    String email = pjson['email'];
    String telefono = pjson['telefono'];
    String tokenid = pjson['tokenid'];
    List<Queue> myQueues = [];
    List<Queue> otherQueues = [];
    User user = User.all(uid, tokenid, nome, cognome, annonascita, sesso, email,
        telefono, myQueues, otherQueues);
    await _initQueue(pjson['myqueues'], user.myQueues, rest, user);
    await _initQueue(pjson['otherqueues'], user.otherQueues, rest, user);
    return user;
  }

  static Future<dynamic> _initQueue(List<dynamic> lstr, List<Queue> lqueues,
      RestFunctions rest, User user) async {
    if (lstr != null) {
      for (dynamic value in lstr) {
        var res = await rest.getQueue(value.toString());
        lqueues.add(await Queue.fromJson(json.decode(res), user));
      }
    }
    return lqueues;
  }

  String get uid => _uid;

  String get anno_nascita => _anno_nascita;

  String get cognome => _cognome;

  String get nome => _nome;

  String get email => _email;

  String get telefono => _telefono;

  String get sesso => _sesso;

  String get tokenid => _tokenid;

  List<Queue> get myQueues => _myQueues;

  List<Queue> get otherQueues => _otherQueues;

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'tokenid': tokenid,
        'nome': nome,
        'cognome': cognome,
        'annonascita': anno_nascita,
        'sesso': sesso,
        'email': email,
        'telefono': telefono,
        'myqueues': myQueues.map((e) => e.id).toList(),
        'otherqueues': myQueues.map((e) => e.id).toList(),
      };
}
