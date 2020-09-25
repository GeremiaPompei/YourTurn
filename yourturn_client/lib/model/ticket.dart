import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/user.dart';
import 'package:yourturn_client/utility/ticketnumber_converter.dart';

class Ticket {
  String _number;
  DateTime _startEnqueue;
  DateTime _stopEnqueue;
  Queue _queue;
  User _user;

  Ticket(this._queue, this._user) {
    _startEnqueue = DateTime.now();
    _number = TicketNumberConverter().fromInt((this._queue.queue.length + 1));
  }

  static Ticket fromJson(Map<String, dynamic> pjson) {}

  User get user => _user;

  Queue get queue => _queue;

  DateTime get stopQueue => _stopEnqueue;

  DateTime get startQueue => _startEnqueue;

  String get number => _number;

  Map<String, dynamic> toMap() => {
        'number': _number,
        'startenqueue': startQueue,
        'stopenqueue': stopQueue,
        'queue': _queue.id,
        'user': _user.uid,
      };
}
