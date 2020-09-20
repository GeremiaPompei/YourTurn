class User {
  String _nome;
  String _cognome;
  String _eta;
  String _email;
  String _telefono;

  User(this._nome, this._cognome, this._eta,this._email,this._telefono);

  String get eta => _eta;

  String get cognome => _cognome;

  String get nome => _nome;

  String get email => _email;

  String get telefono => _telefono;
}