extension NameInputTypeExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    } else {
      return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
    }
  }
}
