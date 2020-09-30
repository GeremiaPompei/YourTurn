import 'dart:convert';
import 'package:yourturn_client/model/rest.dart';
import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/model/user.dart';

class Queue {
  String _id;
  String _luogo;
  User _admin;
  List<Ticket> _tickets;
  DateTime _startDateTime;
  DateTime _stopDateTime;
  bool _isClosed;
  int _index;

  Queue.all(this._id, this._luogo, this._admin, this._tickets,
      this._startDateTime, this._stopDateTime, this._isClosed, this._index);

  static Queue fromJson(Map<String, dynamic> pjson, User user, Ticket ticket) {
    Queue finalQueue;
    String id = pjson['id'];
    int index = pjson['index'];
    String luogo = pjson['luogo'];
    User admin = _initUser(pjson['admin'], user);
    DateTime startDateTime = DateTime.parse(pjson['startdatetime']);
    DateTime stopDateTime;
    bool isClosed;
    if (pjson['stopdatetime'] == null) {
      stopDateTime = null;
      isClosed = false;
    } else {
      stopDateTime = DateTime.parse(pjson['stopdatetime']);
      isClosed = true;
    }
    finalQueue = Queue.all(
        id, luogo, admin, [], startDateTime, stopDateTime, isClosed, index);
    if(ticket != null)
      finalQueue.tickets.forEach((element) {element = ticket;});
    return finalQueue;
  }

  static User _initUser(dynamic value, User user) {
    if (user != null && user.uid == value)
      return user;
    else {
      return User.fromJsonUser(value);
    }
  }

  void close() {
    _isClosed = true;
    _stopDateTime = DateTime.now();
  }

  List<Ticket> get tickets => _tickets;

  User get admin => _admin;

  String get luogo => _luogo;

  String get id => _id;

  DateTime get startDateTime => _startDateTime;

  DateTime get stopDateTime => _stopDateTime;

  bool get isClosed => _isClosed;

  int get index => _index;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'luogo': _luogo,
        'admin': _admin.uid,
        'tickets': _tickets.map((element) => element.numberId).toList(),
        'startdatetime': _startDateTime.toString(),
        'stopdatetime': _stopDateTime == null ? null : _stopDateTime.toString(),
        'index': _index,
      };
}
