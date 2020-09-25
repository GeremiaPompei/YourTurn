import 'dart:convert';

import 'package:yourturn_client/model/rest_functions.dart';
import 'package:yourturn_client/model/user.dart';

class Queue {
  String _id;
  String _luogo;
  User _admin;
  List<User> _queue = [];
  DateTime _startDateTime = DateTime.now();
  DateTime _stopDateTime;
  bool _isClosed = false;

  Queue(this._id, this._luogo, this._admin);

  Queue.all(this._id, this._luogo, this._admin, this._queue,
      this._startDateTime, this._stopDateTime, this._isClosed);

  static Future<Queue> fromJson(Map<String, dynamic> pjson, User user) async {
    RestFunctions rest = new RestFunctions();
    String id = pjson['id'];
    String luogo = pjson['luogo'];
    List<User> lusers = [];
    await _initUser([pjson['admin']], lusers, user, rest);
    User admin = lusers.first;
    List<User> queue = [];
    await _initUser(pjson['queue'], queue, user, rest);
    DateTime startDateTime = DateTime.parse(pjson['startdatetime']);
    DateTime stopDateTime;
    bool isClosed;
    if (pjson['stopdatetime'] == 'null') {
      stopDateTime = null;
      isClosed = false;
    } else {
      stopDateTime = DateTime.parse(pjson['stopdatetime']);
      isClosed = true;
    }
    return Queue.all(
        id, luogo, admin, queue, startDateTime, stopDateTime, isClosed);
  }

  static Future<dynamic> _initUser(List<dynamic> lstr, List<User> lusers,
      User user, RestFunctions rest) async {
    for (dynamic value in lstr) {
      if (user != null && user.uid == value.toString())
        lusers.add(user);
      else {
        Map<String, dynamic> res =
            json.decode(await rest.getUser(value.toString()));
        res['myqueues'] = [];
        res['otherqueues'] = [];
        lusers.add(await User.fromJson(res));
      }
    }
    return lusers;
  }

  void enqueue(User user) {
    this._queue.add(user);
  }

  void dequeue(User user) {
    this._queue.remove(user);
  }

  void next() {
    if (this._queue.isNotEmpty) this._queue.removeAt(0);
  }

  User getFirst() {
    if (this._queue.isNotEmpty)
      return this._queue.first;
    else
      return null;
  }

  void close() {
    this._stopDateTime = DateTime.now();
    this._isClosed = true;
  }

  List<User> get queue => _queue;

  User get admin => _admin;

  String get luogo => _luogo;

  String get id => _id;

  DateTime get startDateTime => _startDateTime;

  DateTime get stopDateTime => _stopDateTime;

  bool get isClosed => _isClosed;

  Map<String, dynamic> toMap() => {
        'id': id,
        'luogo': luogo,
        'admin': admin.uid,
        'queue': queue.map((element) => element.uid).toList(),
        'startdatetime': startDateTime.toString(),
        'stopdatetime': stopDateTime.toString()
      };
}
