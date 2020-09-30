import 'dart:convert';
import 'package:yourturn_client/model/rest.dart';
import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/model/user.dart';

import 'cache.dart';

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

  static Queue fromJson(dynamic pjson, Cache cache) {
    Queue finalQueue;
    String id = pjson['id'];
    int index = pjson['index'];
    String luogo = pjson['luogo'];
    User admin = cache.findUser(pjson['admin']);
    DateTime startDateTime = DateTime.parse(pjson['startdatetime']);
    DateTime stopDateTime;
    bool isClosed = true;
    _initStopDate(pjson['stopdatetime'], stopDateTime, isClosed);
    finalQueue = Queue.all(
        id, luogo, admin, [], startDateTime, stopDateTime, isClosed, index);
    _initTicket(pjson['tickets'], finalQueue.tickets, cache.findTicket);
    return finalQueue;
  }

  static void _initTicket(dynamic lstr, List lt,
      Ticket Function(dynamic) func) {
    if (lstr != null)
      lstr.forEach((element) {
        lt.add(func(element));
      });
  }

  static void _initStopDate(String el, DateTime stopDateTime, bool isClosed) {
    if (el == null) {
      stopDateTime = null;
      isClosed = false;
    } else {
      stopDateTime = DateTime.parse(el);
      isClosed = true;
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
