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
}
