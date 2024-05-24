extension InitialsExtension on String {
  String getInitials() {
    List<String> nameParts = split(" ");
    String initials = "";
    if (nameParts.length == 1) {
      // Only one word in the name
      initials = nameParts[0][0].toUpperCase();
    } else {
      // More than one word in the name
      initials += nameParts[0][0].toUpperCase();
      initials += nameParts.last[0].toUpperCase();
    }
    return initials;
  }

  String toNameFormat() {
    bool isPreviousSpace = false;
    final sb = StringBuffer();
    for (final char in this.runes) {
      if (isPreviousSpace) {
        sb.write(String.fromCharCode(char).toUpperCase());
      } else {
        sb.write(String.fromCharCode(char));
      }
      isPreviousSpace = char == ' '.codeUnits;
    }
    return sb.toString();
  }
}
