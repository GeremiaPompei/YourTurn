import 'dart:convert';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/rest.dart';
import 'cache.dart';
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

  static User fromJson(Map<String, dynamic> pjson, Cache cache) {
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

  static User fromJsonAdmin(Map<String, dynamic> pjson, Cache cache) {
    User user = User.fromJson(pjson, cache);
    cache.listUsers.add(user);
    _initQueue(pjson['myqueues'], user.myQueues, cache.findQueue);
    _initTicket(pjson['tickets'], user.tickets, cache.findTicket);
    return user;
  }

  static void _initQueue(dynamic lstr, List lt, Queue Function(dynamic) func) {
    if (lstr != null)
      lstr.forEach((element) {
        lt.add(func(element));
      });
  }

  static void _initTicket(List lstr, List lt, Ticket Function(dynamic) func) {
    if (lstr != null)
      lstr.forEach((element) {
        lt.add(func(element));
      });
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
