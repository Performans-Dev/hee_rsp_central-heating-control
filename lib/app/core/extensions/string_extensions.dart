import 'package:central_heating_control/app/core/constants/enums.dart';

extension InitialsExtension on String {
/*   String getInitials() {
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
  } */
  String getInitials() {
    // Remove leading and trailing whitespace and split by spaces
    List<String> nameParts = trim().split(" ");

    // Remove any empty strings from the list
    nameParts.removeWhere((part) => part.isEmpty);

    // If no valid name parts exist, return an empty string
    if (nameParts.isEmpty) return '';

    // Initialize the initials
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
    if (isEmpty) return this;
    // Use a regular expression to insert spaces before uppercase letters
    String withSpaces = replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (Match match) => '${match.group(1)} ${match.group(2)}',
    );

    // Capitalize the first letter of the resulting string
    return withSpaces[0].toUpperCase() + withSpaces.substring(1);
  }
}

extension Substring on String {
  /// Returns a substring starting from the beginning of the string
  /// up to the specified length.
  String left(int length) {
    if (length <= 0) {
      return "";
    }
    return substring(0, length.clamp(0, this.length));
  }

  /// Returns a substring starting from the end of the string
  /// with the specified length.
  String right(int length) {
    if (length <= 0) {
      return "";
    }
    return substring(this.length - length.clamp(0, this.length), this.length);
  }
}

extension DiacriticsAwareString on String {
  static const diacritics =
      'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËĚèéêëěðČÇçčÐĎďğIıÌÍÎÏìíîïĽľÙÚÛÜŮùúûüůŇÑñňŘřŞşŠšŤťŸÝÿýŽž';
  static const nonDiacritics =
      'AAAAAAaaaaaaOOOOOOOooooooEEEEEeeeeeeCCccDDdgIiIIIIiiiiLlUUUUUuuuuuNNnnRrSsSsTtYYyyZz';

  String get withoutDiacriticalMarks => splitMapJoin('',
      onNonMatch: (char) => char.isNotEmpty && diacritics.contains(char)
          ? nonDiacritics[diacritics.indexOf(char)]
          : char);
}

extension AppUserLevelExtension on AppUserLevel {
  String get displayName {
    switch (this) {
      case AppUserLevel.developer:
        return 'Developer';
      case AppUserLevel.techSupport:
        return 'Tech Support';
      case AppUserLevel.admin:
        return 'Admin';
      case AppUserLevel.user:
        return 'User';
      default:
        return 'Unknown';
    }
  }
}
