function fromJson(id, luogo, uid) {
    return {
        'id': id,
        'luogo': luogo,
        'admin': uid,
        'tickets': [],
        'startdatetime': new Date().toISOString(),
        'index': 0,
    };
};

module.exports = {
    fromJson,
};