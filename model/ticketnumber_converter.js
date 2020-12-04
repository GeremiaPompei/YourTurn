function fromInt(value) {
    return String.fromCharCode(parseInt(value / 100 + 65)) +
        (value % 100 < 10 ? '0' : '') +
        (value % 100).toString();
}

function fromString(value) {
    return ((value.toString().codeCodeAt(0) - 65) * 100) + parseInt(value.substring(1));
}

module.exports = {
    fromInt,
    fromString
}