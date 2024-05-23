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

extension CamelCaseConverter on String {
  String camelCaseToHumanReadable() {
    // Use a regular expression to insert spaces before uppercase letters
    String withSpaces = replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (Match match) => '${match.group(1)} ${match.group(2)}',
    );

    // Capitalize the first letter of the resulting string
    return withSpaces[0].toUpperCase() + withSpaces.substring(1);
  }
}
