import 'package:yourturn_client/model/queue.dart';

class User {
  String _uid;
  String _tokenid;
  String _nome;
  String _cognome;
  String _anno_nascita;
  String _sesso;
  String _email;
  String _telefono;
  List<Queue> _myQueues = [];
  List<Queue> _otherQueues = [];

  User(this._uid, this._tokenid, this._nome, this._cognome, this._anno_nascita,
      this._sesso, this._email, this._telefono);

  User.fromJson(Map<String, dynamic> json) {
    this._uid = json['uid'];
    this._nome = json['nome'];
    this._cognome = json['cognome'];
    this._anno_nascita = json['annonascita'];
    this._sesso = json['sesso'];
    this._email = json['email'];
    this._telefono = json['telefono'];
    this._telefono = json['tokenid'];
    json['myqueues'].forEach((value) => {this._myQueues.add(value)});
    json['otherqueues'].forEach((value) => {this._otherQueues.add(value)});
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
