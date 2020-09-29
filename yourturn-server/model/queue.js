function fromJson(id, luogo, uid) {
    return {
        'id': id,
        'luogo': luogo,
        'admin': uid,
        'tickets': [],
        'startdatetime': new Date().toISOString(),
        'stopdatetime': null,
        'index': 0,
    };
};

module.exports = {
    fromJson,
};