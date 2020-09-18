import 'package:yourturn_client/model/user.dart';

class Queue {
  final String _id;
  final String _luogo;
  final User _admin;
  final List<User> _queue = [];
  DateTime _startDateTime = DateTime.now();

  Queue(this._id, this._luogo, this._admin);

  void enqueue(User user) {
    this._queue.add(user);
  }

  void dequeue(User user) {
    this._queue.remove(user);
  }

  void next() {
    if(this._queue.isNotEmpty)
      this._queue.removeAt(0);
  }

  User getFirst() {
    if(this._queue.isNotEmpty)
      return this._queue.first;
    else
      return null;
  }

  List<User> get queue => _queue;

  User get admin => _admin;

  String get luogo => _luogo;

  String get id => _id;

  DateTime get startDateTime => _startDateTime;
}
