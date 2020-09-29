import 'dart:convert';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/rest.dart';
import 'ticket.dart';

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
  List<Ticket> _tickets;

  User(this._uid, this._tokenid, this._nome, this._cognome, this._anno_nascita,
      this._sesso, this._email, this._telefono) {
    this._myQueues = [];
    this._tickets = [];
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
      this._tickets);

  static User fromJsonUser(Map<String, dynamic> pjson) {
    String uid = pjson['uid'];
    String nome = pjson['nome'];
    String cognome = pjson['cognome'];
    String annonascita = pjson['annonascita'];
    String sesso = pjson['sesso'];
    String email = pjson['email'];
    String telefono = pjson['telefono'];
    String tokenid = pjson['tokenid'];
    List<Queue> myQueues = [];
    List<Ticket> tickets = [];
    return User.all(uid, tokenid, nome, cognome, annonascita, sesso, email,
        telefono, myQueues, tickets);
  }

  static Future<User> fromJsonAdmin(Map<String, dynamic> pjson) async {
    Rest rest = new Rest();
    User user = User.fromJsonUser(pjson);
    Function funcQueue = (str) async =>
        await Queue.fromJson(json.decode(await rest.getQueue(str)), user);
    await _initT(pjson['myqueues'], user.myQueues, user, funcQueue);
    Function funcTicket = (str) async => await Ticket.fromJson(
        json.decode(await rest.getTicket(str)), user, null);
    await _initT(pjson['tickets'], user.tickets, user, funcTicket);
    return user;
  }

  static Future<dynamic> _initT(
      List<dynamic> lstr, List lt, User user, Function func) async {
    if (lstr != null) {
      for (dynamic value in lstr) {
        lt.add(await func(value.toString()));
      }
    }
    return lt;
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

  List<Ticket> get tickets => _tickets;

  set tokenid(String value) {
    _tokenid = value;
  }

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
        'tickets': tickets.map((e) => e.numberId).toList(),
      };
}
