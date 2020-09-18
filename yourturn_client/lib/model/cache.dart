import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/user.dart';
class Cache {
  User _admin;
  List<Queue> _myQueues;
  List<Queue> _otherQueues;

  Cache() {
    this._myQueues = [];
    this._otherQueues = [];
  }

  User get admin => _admin;

  set admin(User value) {
    _admin = value;
  }

  List<Queue> get myQueues => _myQueues;

  List<Queue> get otherQueues => _otherQueues;
}
