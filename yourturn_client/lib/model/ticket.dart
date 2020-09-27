import 'dart:convert';

import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/rest_functions.dart';
import 'package:yourturn_client/model/user.dart';
import 'package:yourturn_client/utility/ticketnumber_converter.dart';

class Ticket {
  String _numberId;
  DateTime _startEnqueue;
  DateTime _stopEnqueue;
  Queue _queue;
  User _user;

  Ticket(this._queue, this._user) {
    _startEnqueue = DateTime.now();
    _numberId = queue.id +
        '-' +
        TicketNumberConverter().fromInt(this._queue.queue.length + 1);
  }

  Ticket.all(this._numberId, this._startEnqueue, this._stopEnqueue, this._queue,
      this._user);

  static Future<Ticket> fromJson(
      Map<String, dynamic> pjson, User user, Queue queue) async {
    RestFunctions rest = new RestFunctions();
    User finaluser = user != null && pjson['user'] == user.uid
        ? user
        : User.fromJsonUser(json.decode(await rest.getUser(pjson['user'])));
    String number = pjson['numberid'];
    DateTime startEnqueue = DateTime.parse(pjson['startenqueue']);
    DateTime stopEnqueue;
    if (pjson['stopenqueue'] == 'null') {
      stopEnqueue = null;
    } else {
      stopEnqueue = DateTime.parse(pjson['stopenqueue']);
    }
    Queue finalqueue = queue != null
        ? queue
        : await Queue.fromJson(
            json.decode(await rest.getQueue(pjson['queue'])), finaluser);
    return Ticket.all(number, startEnqueue, stopEnqueue, finalqueue, finaluser);
  }

  void close() {
    _stopEnqueue = DateTime.now();
  }

  String get numberCode => _numberId.substring(_numberId.length - 3);

  User get user => _user;

  Queue get queue => _queue;

  DateTime get stopQueue => _stopEnqueue;

  DateTime get startQueue => _startEnqueue;

  String get numberId => _numberId;

  Map<String, dynamic> toMap() => {
        'numberid': _numberId,
        'startenqueue': startQueue.toString(),
        'stopenqueue': stopQueue.toString(),
        'queue': _queue.id,
        'user': _user.uid,
      };
}
