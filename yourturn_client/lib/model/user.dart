class User {
  String _uid;
  String _nome;
  String _cognome;
  String _anno_nascita;
  String _sesso;
  String _email;
  String _telefono;

  User(this._uid, this._nome, this._cognome, this._anno_nascita, this._sesso,
      this._email, this._telefono);

  User.fromJson(Map<String, dynamic> json) {
    this._uid = json['uid'];
    this._nome = json['nome'];
    this._cognome = json['cognome'];
    this._anno_nascita = json['anno_nascita'];
    this._sesso = json['sesso'];
    this._email = json['email'];
    this._telefono = json['telefono'];
  }

  String get uid => _uid;

  String get anno_nascita => _anno_nascita;

  String get cognome => _cognome;

  String get nome => _nome;

  String get email => _email;

  String get telefono => _telefono;

  String get sesso => _sesso;

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'nome': nome,
        'cognome': cognome,
        'anno_nascita': anno_nascita,
        'sesso': sesso,
        'email': email,
        'telefono': telefono
      };
}
