import 'package:yourturn_client/model/queue.dart';
import 'cache.dart';
import 'ticket.dart';

class User {
  String _uid;
  List<String> _tokenid;
  String _nome;
  String _cognome;
  String _annonascita;
  String _sesso;
  String _email;
  String _telefono;
  Queue _queue;
  List<Ticket> _tickets;

  User.all(
      this._uid,
      this._tokenid,
      this._nome,
      this._cognome,
      this._annonascita,
      this._sesso,
      this._email,
      this._telefono,
      this._queue,
      this._tickets);

  static User fromJson(dynamic pjson, Cache cache) {
    String uid = pjson['uid'];
    String nome = pjson['nome'];
    String cognome = pjson['cognome'];
    String annonascita = pjson['annonascita'];
    String sesso = pjson['sesso'];
    String email = pjson['email'];
    String telefono = pjson['telefono'];
    Queue queue = cache.findQueue(pjson['queue']);
    return User.all(
        uid, [], nome, cognome, annonascita, sesso, email, telefono, queue, []);
  }

  static User fromJsonAdmin(dynamic pjson, Cache cache) {
    User user = User.fromJson(pjson, cache);
    cache.listUsers.add(user);
    pjson['tokenid'].forEach((el) {
      user.tokenid.add(el);
    });
    pjson['tickets'].forEach((element) {
      user.tickets.add(cache.findTicket(element));
    });
    return user;
  }

  String get uid => _uid;

  String get annonascita => _annonascita;

  String get cognome => _cognome;

  String get nome => _nome;

  String get email => _email;

  String get telefono => _telefono;

  String get sesso => _sesso;

  List<String> get tokenid => _tokenid;

  Queue get queue => _queue;

  List<Ticket> get tickets => _tickets;

  set queue(Queue value) {
    _queue = value;
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'tokenid': tokenid,
        'nome': nome,
        'cognome': cognome,
        'annonascita': annonascita,
        'sesso': sesso,
        'email': email,
        'telefono': telefono,
        'queue': queue.id,
        'tickets': tickets.map((e) => e.numberId).toList(),
      };
}
