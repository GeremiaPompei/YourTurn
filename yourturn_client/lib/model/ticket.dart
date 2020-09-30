import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/user.dart';
import 'cache.dart';

class Ticket {
  String _numberId;
  DateTime _startEnqueue;
  DateTime _stopEnqueue;
  Queue _queue;
  User _user;

  Ticket.all(this._numberId, this._startEnqueue, this._stopEnqueue, this._queue,
      this._user);

  static Ticket fromJson(dynamic pjson, Cache cache) {
    User finaluser = cache.findUser(pjson['user']);
    String number = pjson['numberid'];
    DateTime startEnqueue = DateTime.parse(pjson['startenqueue']);
    DateTime stopEnqueue = pjson['stopenqueue'] == null
        ? null
        : DateTime.parse(pjson['stopenqueue']);
    Queue finalQueue = cache.findQueue(pjson['queue']);
    return Ticket.all(number, startEnqueue, stopEnqueue, finalQueue, finaluser);
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
        'stopenqueue': stopQueue == null ? null : stopQueue.toString(),
        'queue': _queue.id,
        'user': _user.uid,
      };
}
