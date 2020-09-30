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

  User findUser(dynamic pjson) {
    try {
      List<User> searched;
      try {
        searched = this
            ._listUsers
            .where((element) => element.uid == pjson['uid'])
            .toList();
      } catch (e) {
        searched = this
            ._listUsers
            .where((element) => element.uid == pjson)
            .toList();
      }
      if (searched.isNotEmpty) {
        return searched.first;
      } else {
        User user = User.fromJson(pjson, this);
        listUsers.add(user);
        return user;
      }
    } catch (e) {
      return null;
    }
  }

  Queue findQueue(dynamic pjson) {
    try {
      List<Queue> searched = this
          ._listQueues
          .where((element) => element.id == pjson['id'])
          .toList();
      if (searched.isNotEmpty) {
        return searched.first;
      } else {
        Queue queue = Queue.fromJson(pjson, this);
        listQueues.add(queue);
        return queue;
      }
    } catch (e) {
      return null;
    }
  }

  Ticket findTicket(dynamic pjson) {
    try {
      List<Ticket> searched = this
          ._listTickets
          .where((element) => element.numberId == pjson['numberid'])
          .toList();
      if (searched.isNotEmpty) {
        return searched.first;
      } else {
        Ticket ticket = Ticket.fromJson(pjson, this);
        listTickets.add(ticket);
        return ticket;
      }
    } catch (e) {
      return null;
    }
  }

  Set<Ticket> get listTickets => _listTickets;

  Set<Queue> get listQueues => _listQueues;

  Set<User> get listUsers => _listUsers;
}
