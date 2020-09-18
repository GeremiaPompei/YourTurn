import 'package:yourturn_client/model/cache.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/user.dart';

class MainController {
  Cache _cache;
  bool _authenticate;

  MainController() {
    this._authenticate = false;
    this._cache = new Cache();
  }

  void createQueue(String id, String luogo) =>
      myQueues.add(new Queue(id, luogo, admin));

  void enqueue(User user) => myQueues.last.enqueue(user);

  void dequeue(User user) => myQueues.last.dequeue(user);

  void next() => myQueues.last.next();

  User get first => myQueues.last.getFirst();

  List<Queue> get myQueues => _cache.myQueues;

  List<Queue> get otherQueues => _cache.otherQueues;

  bool get authenticate => _authenticate;

  User get admin => this._cache.admin;

  set admin (User value) {
    this._cache.admin = value;
  }
}
