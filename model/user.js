function fromJson(uid, tokenid, nome, cognome, annonascita, sesso, email, telefono) {
    return {
        'uid': uid,
        'tokenid': tokenid,
        'nome': nome,
        'cognome': cognome,
        'annonascita': annonascita,
        'sesso': sesso,
        'email': email,
        'telefono': telefono,
        'queue': null,
        'tickets': [],
    };
};

module.exports = {
    fromJson,
};