function fromJson(uid, id, numberid) {
    return {
        'numberid': numberid,
        'startenqueue': new Date().toISOString(),
        'stopenqueue': null,
        'queue': id,
        'user': uid,
    };
};

module.exports = {
    fromJson,
};