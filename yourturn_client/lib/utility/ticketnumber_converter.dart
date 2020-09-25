class TicketNumberConverter {
  String fromInt(int value) =>
      String.fromCharCode((value / 100 + 64) as int) +
      (value % 100 < 10 ? '0' : '') +
      (value % 100).toString();

  int fromString(String value) =>
      ((value.codeUnitAt(0) - 42) * 100) + int.parse(value.substring(1));
}
