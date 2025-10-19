extension DateFormatExtention on DateTime {
  String format() {
    return "${day.toString().padLeft(2, '0')}/"
        "${month.toString().padLeft(2, '0')}"
        "$year";
  }
}
