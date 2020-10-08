import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/user.dart';
import 'cache.dart';

class Ticket {
  String _numberId;
  DateTime _startEnqueue;
  Queue _queue;
  User _user;

  Ticket.all(this._numberId, this._startEnqueue, this._queue, this._user);

  static Ticket fromJson(dynamic pjson, Cache cache) {
    String number = pjson['numberid'];
    DateTime startEnqueue = DateTime.parse(pjson['startenqueue']);
    Queue finalQueue = cache.findQueue(pjson['queue']);
    User finaluser = cache.findUser(pjson['user']);
    return Ticket.all(number, startEnqueue, finalQueue, finaluser);
  }

  String get numberCode => _numberId.substring(_numberId.length - 3);

  User get user => _user;

  Queue get queue => _queue;

  DateTime get startQueue => _startEnqueue;

  String get numberId => _numberId;

  Map<String, dynamic> toMap() => {
        'numberid': _numberId,
        'startenqueue': startQueue.toString(),
        'queue': _queue.id,
        'user': _user.uid,
      };
}
