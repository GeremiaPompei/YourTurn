class TicketNumberConverter {
  String fromInt(int value) {
    return String.fromCharCode((value / 100 + 65).toInt()) +
        (value % 100 < 10 ? '0' : '') +
        (value % 100).toString();
  }

  int fromString(String value) =>
      ((value.codeUnitAt(0) - 65) * 100) + int.parse(value.substring(1));
}
