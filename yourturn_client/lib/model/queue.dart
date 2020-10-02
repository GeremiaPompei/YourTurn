import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/model/user.dart';

import 'cache.dart';

class Queue {
  String _id;
  String _luogo;
  User _admin;
  List<Ticket> _tickets;
  DateTime _startDateTime;
  int _index;

  Queue.all(this._id, this._luogo, this._admin, this._tickets,
      this._startDateTime, this._index);

  static Queue fromJson(dynamic pjson, Cache cache) {
    Queue finalQueue;
    String id = pjson['id'];
    int index = pjson['index'];
    String luogo = pjson['luogo'];
    User admin = cache.findUser(pjson['admin']);
    DateTime startDateTime = DateTime.parse(pjson['startdatetime']);
    finalQueue = Queue.all(id, luogo, admin, [], startDateTime, index);
    _initTicket(pjson['tickets'], finalQueue.tickets, cache.findTicket);
    return finalQueue;
  }

  static void _initTicket(
      dynamic lstr, List lt, Ticket Function(dynamic) func) {
    if (lstr != null)
      lstr.forEach((element) {
        lt.add(func(element));
      });
  }

  List<Ticket> get tickets => _tickets;

  User get admin => _admin;

  String get luogo => _luogo;

  String get id => _id;

  DateTime get startDateTime => _startDateTime;

  int get index => _index;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'luogo': _luogo,
        'admin': _admin.uid,
        'tickets': _tickets.map((element) => element.numberId).toList(),
        'startdatetime': _startDateTime.toString(),
        'index': _index,
      };
}
