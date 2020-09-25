class ErrMessagesManager {
  Map<String, String> _allMex;

  ErrMessagesManager(this._allMex);

  ErrMessagesManager.fromList(List<String> keys) {
    _allMex = {};
    keys.forEach((element) {
      _allMex[element] = null;
    });
  }

  void manage(Map<String, String> newMex) {
    _allMex.keys.forEach((element) {
      if (newMex.keys.contains(element))
        _allMex[element] = newMex[element];
      else
        _allMex[element] = null;
    });
  }

  void checkEmpty(Map<String, String> toCheck) {
    toCheck.keys.forEach((element) {
      if (_allMex.keys.contains(element)) {
        if (toCheck[element] == null || toCheck[element].isEmpty)
          _allMex[element] = 'Inserire ' + element.toUpperCase();
        else
          _allMex[element] = null;
      }
    });
  }

  Map<String, String> get allMex => _allMex;
}
