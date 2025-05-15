
extension StringExtension on String {
  String toUpperCaseTr() {
    return replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();
  }
  String toLowerCaseTr() {
    return replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();
  }
}