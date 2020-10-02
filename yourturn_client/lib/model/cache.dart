import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/model/user.dart';

class Cache {
  Set<User> _listUsers;
  Set<Queue> _listQueues;
  Set<Ticket> _listTickets;

  Cache() {
    this._listUsers = {};
    this._listQueues = {};
    this._listTickets = {};
  }

  T _findElement<T>(dynamic pjson, Set<T> resultElements, List<T> searched,
      T Function(dynamic, Cache) fromJson) {
    try {
      if (searched.isNotEmpty) {
        return searched.first;
      } else {
        T element = fromJson(pjson, this);
        resultElements.add(element);
        return element;
      }
    } catch (e) {}
  }

  User findUser(dynamic pjson) {
    String txt = pjson.runtimeType == String ? pjson : pjson['uid'];
    List<User> searched =
        this._listUsers.where((element) => element.uid == txt).toList();
    return _findElement<User>(pjson, this._listUsers, searched, User.fromJson);
  }

  Queue findQueue(dynamic pjson) {
    if (pjson != null) {
      String txt = pjson.runtimeType == String ? pjson : pjson['id'];
      List<Queue> searched =
          this._listQueues.where((element) => element.id == txt).toList();
      return _findElement<Queue>(
          pjson, this._listQueues, searched, Queue.fromJson);
    }
  }

  Ticket findTicket(dynamic pjson) {
    String txt = pjson.runtimeType == String ? pjson : pjson['numberid'];
    List<Ticket> searched =
        this._listTickets.where((element) => element.numberId == txt).toList();
    return _findElement<Ticket>(
        pjson, this._listTickets, searched, Ticket.fromJson);
  }

  Set<Ticket> get listTickets => _listTickets;

  Set<Queue> get listQueues => _listQueues;

  Set<User> get listUsers => _listUsers;
}
