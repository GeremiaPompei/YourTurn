import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/rest.dart';
import 'package:yourturn_client/model/user.dart';
import 'package:yourturn_client/utility/ticketnumber_converter.dart';

class Ticket {
  String _numberId;
  DateTime _startEnqueue;
  DateTime _stopEnqueue;
  Queue _queue;
  User _user;

  Ticket.all(this._numberId, this._startEnqueue, this._stopEnqueue, this._queue,
      this._user);

  static Ticket fromJson(
      Map<String, dynamic> pjson, User user, Queue queue) {
    Ticket finalTicket;
    User finaluser = user != null && pjson['user'] == user.uid
        ? user
        : User.fromJsonUser(pjson['user']);
    String number = pjson['numberid'];
    DateTime startEnqueue = DateTime.parse(pjson['startenqueue']);
    DateTime stopEnqueue;
    if (pjson['stopenqueue'] == null) {
      stopEnqueue = null;
    } else {
      stopEnqueue = DateTime.parse(pjson['stopenqueue']);
    }
    finalTicket = Ticket.all(number, startEnqueue, stopEnqueue, null, finaluser);
    finalTicket.queue = queue != null
        ? queue
        : Queue.fromJson(pjson['queue'], finaluser, finalTicket);
    return finalTicket;
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

  set queue(Queue value) {
    _queue = value;
  }

  Map<String, dynamic> toMap() => {
        'numberid': _numberId,
        'startenqueue': startQueue.toString(),
        'stopenqueue': stopQueue == null ? null : stopQueue.toString(),
        'queue': _queue.id,
        'user': _user.uid,
      };
}
