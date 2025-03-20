import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/data/models/preferences/language.dart';
import 'package:central_heating_control/app/data/models/preferences/timezone.dart';

class StaticProvider {
  //#region MARK: Preferences

  static List<String> getDateFormatList = [
    "yyyy-MM-dd", // 2024-06-07
    "MM/dd/yyyy", // 06/07/2024
    "dd/MM/yyyy", // 07/06/2024
    "dd-MM-yyyy", // 07-06-2024
    "yyyy/MM/dd", // 2024/06/07
    "EEE, MMM d, yyyy", // Fri, Jun 7, 2024
    "EEE, MMM d", // Fri, Jun 7
    "MMMM d, yyyy", // June 7, 2024
    "MMM d, yyyy", // Jun 7, 2024
    "dd MMMM yyyy", // 07 June 2024
    'd MMM, EEE',
  ];

  static List<String> getTimeFormatList = [
    "HH:mm",
    "hh:mm a",
    "HH:mm:ss",
    "hh:mm:ss a",
  ];

  static List<Language> getLanguageList = [
    Language(code: 'en', country: 'US', name: 'English'),
    Language(code: 'tr', country: 'TR', name: 'Türkçe'),
  ];

  static List<Timezone> getTimezoneList = [
    Timezone.fromMap({
      "zone": "Pacific/Midway",
      "gmt": "(GMT-11:00)",
      "name": "Midway Island"
    }),
    Timezone.fromMap(
        {"zone": "US/Samoa", "gmt": "(GMT-11:00)", "name": "Samoa"}),
    Timezone.fromMap(
        {"zone": "US/Hawaii", "gmt": "(GMT-10:00)", "name": "Hawaii"}),
    Timezone.fromMap(
        {"zone": "US/Alaska", "gmt": "(GMT-09:00)", "name": "Alaska"}),
    Timezone.fromMap({
      "zone": "US/Pacific",
      "gmt": "(GMT-08:00)",
      "name": "Pacific Time (US &amp; Canada)"
    }),
    Timezone.fromMap(
        {"zone": "America/Tijuana", "gmt": "(GMT-08:00)", "name": "Tijuana"}),
    Timezone.fromMap(
        {"zone": "US/Arizona", "gmt": "(GMT-07:00)", "name": "Arizona"}),
    Timezone.fromMap({
      "zone": "US/Mountain",
      "gmt": "(GMT-07:00)",
      "name": "Mountain Time (US &amp; Canada)"
    }),
    Timezone.fromMap({
      "zone": "America/Chihuahua",
      "gmt": "(GMT-07:00)",
      "name": "Chihuahua"
    }),
    Timezone.fromMap(
        {"zone": "America/Mazatlan", "gmt": "(GMT-07:00)", "name": "Mazatlan"}),
    Timezone.fromMap({
      "zone": "America/Mexico_City",
      "gmt": "(GMT-06:00)",
      "name": "Mexico City"
    }),
    Timezone.fromMap({
      "zone": "America/Monterrey",
      "gmt": "(GMT-06:00)",
      "name": "Monterrey"
    }),
    Timezone.fromMap({
      "zone": "Canada/Saskatchewan",
      "gmt": "(GMT-06:00)",
      "name": "Saskatchewan"
    }),
    Timezone.fromMap({
      "zone": "US/Central",
      "gmt": "(GMT-06:00)",
      "name": "Central Time (US &amp; Canada)"
    }),
    Timezone.fromMap({
      "zone": "US/Eastern",
      "gmt": "(GMT-05:00)",
      "name": "Eastern Time (US &amp; Canada)"
    }),
    Timezone.fromMap({
      "zone": "US/East-Indiana",
      "gmt": "(GMT-05:00)",
      "name": "Indiana (East)"
    }),
    Timezone.fromMap(
        {"zone": "America/Bogota", "gmt": "(GMT-05:00)", "name": "Bogota"}),
    Timezone.fromMap(
        {"zone": "America/Lima", "gmt": "(GMT-05:00)", "name": "Lima"}),
    Timezone.fromMap(
        {"zone": "America/Caracas", "gmt": "(GMT-04:30)", "name": "Caracas"}),
    Timezone.fromMap({
      "zone": "Canada/Atlantic",
      "gmt": "(GMT-04:00)",
      "name": "Atlantic Time (Canada)"
    }),
    Timezone.fromMap(
        {"zone": "America/La_Paz", "gmt": "(GMT-04:00)", "name": "La_Paz"}),
    Timezone.fromMap(
        {"zone": "America/Santiago", "gmt": "(GMT-04:00)", "name": "Santiago"}),
    Timezone.fromMap({
      "zone": "Canada/Newfoundland",
      "gmt": "(GMT-03:30)",
      "name": "Newfoundland"
    }),
    Timezone.fromMap({
      "zone": "America/Buenos_Aires",
      "gmt": "(GMT-03:00)",
      "name": "Buenos Aires"
    }),
    Timezone.fromMap(
        {"zone": "Greenland", "gmt": "(GMT-03:00)", "name": "Greenland"}),
    Timezone.fromMap(
        {"zone": "Atlantic/Stanley", "gmt": "(GMT-02:00)", "name": "Stanley"}),
    Timezone.fromMap(
        {"zone": "Atlantic/Azores", "gmt": "(GMT-01:00)", "name": "Azores"}),
    Timezone.fromMap({
      "zone": "Atlantic/Cape_Verde",
      "gmt": "(GMT-01:00)",
      "name": "Cape Verde Is."
    }),
    Timezone.fromMap(
        {"zone": "Africa/Casablanca", "gmt": "(GMT)", "name": "Casablanca"}),
    Timezone.fromMap(
        {"zone": "Europe/Dublin", "gmt": "(GMT)", "name": "Dublin"}),
    Timezone.fromMap(
        {"zone": "Europe/Lisbon", "gmt": "(GMT)", "name": "Libson"}),
    Timezone.fromMap(
        {"zone": "Europe/London", "gmt": "(GMT)", "name": "London"}),
    Timezone.fromMap(
        {"zone": "Africa/Monrovia", "gmt": "(GMT)", "name": "Monrovia"}),
    Timezone.fromMap({
      "zone": "Europe/Amsterdam",
      "gmt": "(GMT+01:00)",
      "name": "Amsterdam"
    }),
    Timezone.fromMap(
        {"zone": "Europe/Belgrade", "gmt": "(GMT+01:00)", "name": "Belgrade"}),
    Timezone.fromMap(
        {"zone": "Europe/Berlin", "gmt": "(GMT+01:00)", "name": "Berlin"}),
    Timezone.fromMap({
      "zone": "Europe/Bratislava",
      "gmt": "(GMT+01:00)",
      "name": "Bratislava"
    }),
    Timezone.fromMap(
        {"zone": "Europe/Brussels", "gmt": "(GMT+01:00)", "name": "Brussels"}),
    Timezone.fromMap(
        {"zone": "Europe/Budapest", "gmt": "(GMT+01:00)", "name": "Budapest"}),
    Timezone.fromMap({
      "zone": "Europe/Copenhagen",
      "gmt": "(GMT+01:00)",
      "name": "Copenhagen"
    }),
    Timezone.fromMap({
      "zone": "Europe/Ljubljana",
      "gmt": "(GMT+01:00)",
      "name": "Ljubljana"
    }),
    Timezone.fromMap(
        {"zone": "Europe/Madrid", "gmt": "(GMT+01:00)", "name": "Madrid"}),
    Timezone.fromMap(
        {"zone": "Europe/Paris", "gmt": "(GMT+01:00)", "name": "Paris"}),
    Timezone.fromMap(
        {"zone": "Europe/Prague", "gmt": "(GMT+01:00)", "name": "Prague"}),
    Timezone.fromMap(
        {"zone": "Europe/Rome", "gmt": "(GMT+01:00)", "name": "Rome"}),
    Timezone.fromMap(
        {"zone": "Europe/Sarajevo", "gmt": "(GMT+01:00)", "name": "Sarajevo"}),
    Timezone.fromMap(
        {"zone": "Europe/Skopje", "gmt": "(GMT+01:00)", "name": "Skopje"}),
    Timezone.fromMap({
      "zone": "Europe/Stockholm",
      "gmt": "(GMT+01:00)",
      "name": "Stockholm"
    }),
    Timezone.fromMap(
        {"zone": "Europe/Vienna", "gmt": "(GMT+01:00)", "name": "Vienna"}),
    Timezone.fromMap(
        {"zone": "Europe/Warsaw", "gmt": "(GMT+01:00)", "name": "Warsaw"}),
    Timezone.fromMap(
        {"zone": "Europe/Zagreb", "gmt": "(GMT+01:00)", "name": "Zagreb"}),
    Timezone.fromMap(
        {"zone": "Europe/Athens", "gmt": "(GMT+02:00)", "name": "Athens"}),
    Timezone.fromMap({
      "zone": "Europe/Bucharest",
      "gmt": "(GMT+02:00)",
      "name": "Bucharest"
    }),
    Timezone.fromMap(
        {"zone": "Africa/Cairo", "gmt": "(GMT+02:00)", "name": "Cairo"}),
    Timezone.fromMap(
        {"zone": "Africa/Harare", "gmt": "(GMT+02:00)", "name": "Harere"}),
    Timezone.fromMap(
        {"zone": "Europe/Helsinki", "gmt": "(GMT+02:00)", "name": "Helsinki"}),
    Timezone.fromMap(
        {"zone": "Europe/Istanbul", "gmt": "(GMT+02:00)", "name": "Istanbul"}),
    Timezone.fromMap(
        {"zone": "Asia/Jerusalem", "gmt": "(GMT+02:00)", "name": "Jerusalem"}),
    Timezone.fromMap(
        {"zone": "Europe/Kiev", "gmt": "(GMT+02:00)", "name": "Kiev"}),
    Timezone.fromMap(
        {"zone": "Europe/Minsk", "gmt": "(GMT+02:00)", "name": "Minsk"}),
    Timezone.fromMap(
        {"zone": "Europe/Riga", "gmt": "(GMT+02:00)", "name": "Riga"}),
    Timezone.fromMap(
        {"zone": "Europe/Sofia", "gmt": "(GMT+02:00)", "name": "Sofia"}),
    Timezone.fromMap(
        {"zone": "Europe/Tallinn", "gmt": "(GMT+02:00)", "name": "Tallinn"}),
    Timezone.fromMap(
        {"zone": "Europe/Vilnius", "gmt": "(GMT+02:00)", "name": "Vilnius"}),
    Timezone.fromMap(
        {"zone": "Asia/Baghdad", "gmt": "(GMT+03:00)", "name": "Baghdad"}),
    Timezone.fromMap(
        {"zone": "Asia/Kuwait", "gmt": "(GMT+03:00)", "name": "Kuwait"}),
    Timezone.fromMap(
        {"zone": "Africa/Nairobi", "gmt": "(GMT+03:00)", "name": "Nairobi"}),
    Timezone.fromMap(
        {"zone": "Asia/Riyadh", "gmt": "(GMT+03:00)", "name": "Riyadh"}),
    Timezone.fromMap(
        {"zone": "Asia/Tehran", "gmt": "(GMT+03:30)", "name": "Tehran"}),
    Timezone.fromMap(
        {"zone": "Europe/Moscow", "gmt": "(GMT+04:00)", "name": "Moscow"}),
    Timezone.fromMap(
        {"zone": "Asia/Baku", "gmt": "(GMT+04:00)", "name": "Baku"}),
    Timezone.fromMap({
      "zone": "Europe/Volgograd",
      "gmt": "(GMT+04:00)",
      "name": "Volgograd"
    }),
    Timezone.fromMap(
        {"zone": "Asia/Muscat", "gmt": "(GMT+04:00)", "name": "Muscat"}),
    Timezone.fromMap(
        {"zone": "Asia/Tbilisi", "gmt": "(GMT+04:00)", "name": "Tbilisi"}),
    Timezone.fromMap(
        {"zone": "Asia/Yerevan", "gmt": "(GMT+04:00)", "name": "Yerevan"}),
    Timezone.fromMap(
        {"zone": "Asia/Kabul", "gmt": "(GMT+04:30)", "name": "Kabul"}),
    Timezone.fromMap(
        {"zone": "Asia/Karachi", "gmt": "(GMT+05:00)", "name": "Karachi"}),
    Timezone.fromMap(
        {"zone": "Asia/Tashkent", "gmt": "(GMT+05:00)", "name": "Tashkent"}),
    Timezone.fromMap(
        {"zone": "Asia/Kolkata", "gmt": "(GMT+05:30)", "name": "Kolkata"}),
    Timezone.fromMap(
        {"zone": "Asia/Kathmandu", "gmt": "(GMT+05:45)", "name": "Kathmandu"}),
    Timezone.fromMap({
      "zone": "Asia/Yekaterinburg",
      "gmt": "(GMT+06:00)",
      "name": "Yekaterinburg"
    }),
    Timezone.fromMap(
        {"zone": "Asia/Almaty", "gmt": "(GMT+06:00)", "name": "Almaty"}),
    Timezone.fromMap(
        {"zone": "Asia/Dhaka", "gmt": "(GMT+06:00)", "name": "Dhaka"}),
    Timezone.fromMap({
      "zone": "Asia/Novosibirsk",
      "gmt": "(GMT+07:00)",
      "name": "Novosibirsk"
    }),
    Timezone.fromMap(
        {"zone": "Asia/Bangkok", "gmt": "(GMT+07:00)", "name": "Bangkok"}),
    Timezone.fromMap(
        {"zone": "Asia/Jakarta", "gmt": "(GMT+07:00)", "name": "Jakarta"}),
    Timezone.fromMap({
      "zone": "Asia/Krasnoyarsk",
      "gmt": "(GMT+08:00)",
      "name": "Krasnoyarsk"
    }),
    Timezone.fromMap(
        {"zone": "Asia/Chongqing", "gmt": "(GMT+08:00)", "name": "Chongqing"}),
    Timezone.fromMap(
        {"zone": "Asia/Hong_Kong", "gmt": "(GMT+08:00)", "name": "Hong Kong"}),
    Timezone.fromMap({
      "zone": "Asia/Kuala_Lumpur",
      "gmt": "(GMT+08:00)",
      "name": "Kuala Lumpur"
    }),
    Timezone.fromMap(
        {"zone": "Australia/Perth", "gmt": "(GMT+08:00)", "name": "Perth"}),
    Timezone.fromMap(
        {"zone": "Asia/Singapore", "gmt": "(GMT+08:00)", "name": "Singapore"}),
    Timezone.fromMap(
        {"zone": "Asia/Taipei", "gmt": "(GMT+08:00)", "name": "Taipei"}),
    Timezone.fromMap({
      "zone": "Asia/Ulaanbaatar",
      "gmt": "(GMT+08:00)",
      "name": "Ulaan Bataar"
    }),
    Timezone.fromMap(
        {"zone": "Asia/Urumqi", "gmt": "(GMT+08:00)", "name": "Urumqi"}),
    Timezone.fromMap(
        {"zone": "Asia/Irkutsk", "gmt": "(GMT+09:00)", "name": "Irkutsk"}),
    Timezone.fromMap(
        {"zone": "Asia/Seoul", "gmt": "(GMT+09:00)", "name": "Seoul"}),
    Timezone.fromMap(
        {"zone": "Asia/Tokyo", "gmt": "(GMT+09:00)", "name": "Tokyo"}),
    Timezone.fromMap({
      "zone": "Australia/Adelaide",
      "gmt": "(GMT+09:30)",
      "name": "Adelaide"
    }),
    Timezone.fromMap(
        {"zone": "Australia/Darwin", "gmt": "(GMT+09:30)", "name": "Darwin"}),
    Timezone.fromMap(
        {"zone": "Asia/Yakutsk", "gmt": "(GMT+10:00)", "name": "Yakutsk"}),
    Timezone.fromMap({
      "zone": "Australia/Brisbane",
      "gmt": "(GMT+10:00)",
      "name": "Brisbane"
    }),
    Timezone.fromMap({
      "zone": "Australia/Canberra",
      "gmt": "(GMT+10:00)",
      "name": "Canberra"
    }),
    Timezone.fromMap(
        {"zone": "Pacific/Guam", "gmt": "(GMT+10:00)", "name": "Guam"}),
    Timezone.fromMap(
        {"zone": "Australia/Hobart", "gmt": "(GMT+10:00)", "name": "Hobart"}),
    Timezone.fromMap({
      "zone": "Australia/Melbourne",
      "gmt": "(GMT+10:00)",
      "name": "Melbourne"
    }),
    Timezone.fromMap({
      "zone": "Pacific/Port_Moresby",
      "gmt": "(GMT+10:00)",
      "name": "Port Moresby"
    }),
    Timezone.fromMap(
        {"zone": "Australia/Sydney", "gmt": "(GMT+10:00)", "name": "Sydney"}),
    Timezone.fromMap({
      "zone": "Asia/Vladivostok",
      "gmt": "(GMT+11:00)",
      "name": "Vladivostok"
    }),
    Timezone.fromMap(
        {"zone": "Asia/Magadan", "gmt": "(GMT+12:00)", "name": "Magadan"}),
    Timezone.fromMap(
        {"zone": "Pacific/Auckland", "gmt": "(GMT+12:00)", "name": "Auckland"}),
    Timezone.fromMap(
        {"zone": "Pacific/Fiji", "gmt": "(GMT+12:00)", "name": "Fiji"}),
  ];

  static final List<String> getThemeList = [
    Keys.themeDefault,
    Keys.themeNature,
    Keys.themeWarmy,
    Keys.themeCrimson,
  ];

  //#endregion
}
