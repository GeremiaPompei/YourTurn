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

  User.fromJson(Map<String, dynamic> pjson, Queue queue) {
    RestFunctions rest = new RestFunctions();
    this._uid = pjson['uid'];
    this._nome = pjson['nome'];
    this._cognome = pjson['cognome'];
    this._anno_nascita = pjson['annonascita'];
    this._sesso = pjson['sesso'];
    this._email = pjson['email'];
    this._telefono = pjson['telefono'];
    this._telefono = pjson['tokenid'];
    this._myQueues = [];
    this._otherQueues = [];
    _initQueue('myqueue', this._myQueues, queue, pjson, rest);
    _initQueue('otherqueue', this._otherQueues, queue, pjson, rest);
  }

  void _initQueue(String title, List<Queue> lqueues, Queue queue,
      Map<String, dynamic> pjson, RestFunctions rest) async {
    for (dynamic value in pjson[title]) {
      if (queue != null && queue.id == value)
        lqueues.add(queue);
      else {
        var res = await rest.getQueue(value);
        lqueues.add(Queue.fromJson(json.decode(res), this));
      }
    }
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
