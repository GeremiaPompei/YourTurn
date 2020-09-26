import 'dart:convert';
import 'package:yourturn_client/model/rest_functions.dart';
import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/model/user.dart';

class Queue {
  String _id;
  String _luogo;
  User _admin;
  List<Ticket> _queue;
  DateTime _startDateTime;
  DateTime _stopDateTime;
  bool _isClosed;

  Queue(this._id, this._luogo, this._admin) {
    _queue = [];
    _startDateTime = DateTime.now();
    _isClosed = false;
  }

  Queue.all(this._id, this._luogo, this._admin, this._queue,
      this._startDateTime, this._stopDateTime, this._isClosed);

  static Future<Queue> fromJson(Map<String, dynamic> pjson, User user) async {
    Queue finalQueue;
    RestFunctions rest = new RestFunctions();
    String id = pjson['id'];
    String luogo = pjson['luogo'];
    User admin = await _initUser(pjson['admin'], user, rest);
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
    finalQueue = Queue.all(
        id, luogo, admin, [], startDateTime, stopDateTime, isClosed);
    await _initTicket(pjson['queue'], finalQueue.queue, rest, finalQueue, user);
    return finalQueue;
  }

  static Future<User> _initUser(
      String value, User user, RestFunctions rest) async {
    if (user != null && user.uid == value.toString())
      return user;
    else {
      Map<String, dynamic> res =
          json.decode(await rest.getUser(value.toString()));
      return User.fromJsonUser(res);
    }
  }

  static Future<dynamic> _initTicket(
      List<dynamic> lstr, List<Ticket> lt, RestFunctions rest, Queue queue, User user) async {
    for (dynamic value in lstr) {
      Map<String, dynamic> res = json.decode(await rest.getTicket(value));
      lt.add(await Ticket.fromJson(res, user, queue));
    }
    return lt;
  }

  List<Ticket> get queue => _queue;

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
        'queue': queue.map((element) => element.numberId).toList(),
        'startdatetime': startDateTime.toString(),
        'stopdatetime': stopDateTime.toString()
      };
}
