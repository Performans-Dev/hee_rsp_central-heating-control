import 'dart:async';

import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class LiveDateTimeDisplay extends StatefulWidget {
  const LiveDateTimeDisplay({
    super.key,
    this.dateFormat,
    this.timeFormat,
    this.fontSize,
    this.force2Line = false,
  });
  final String? dateFormat;
  final String? timeFormat;
  final double? fontSize;
  final bool force2Line;

  @override
  State<LiveDateTimeDisplay> createState() => _LiveDateTimeDisplayState();
}

class _LiveDateTimeDisplayState extends State<LiveDateTimeDisplay> {
  final AppController appController = Get.find();
  late Timer _timer;
  DateTime _currentDateTime = DateTime.now();
  String? _currentLocale;

  @override
  void initState() {
    super.initState();
    // Initialize the locale for date formatting
    _initializeLocale();

    // Update the time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
        // Check if locale has changed
        final language = appController.preferences.language;
        final newLocale = '${language.code}_${language.country}';
        if (newLocale != _currentLocale) {
          _initializeLocale();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Initialize the locale for date formatting
  Future<void> _initializeLocale() async {
    final language = appController.preferences.language;
    _currentLocale = '${language.code}_${language.country}';
    await initializeDateFormatting(_currentLocale);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat =
        widget.dateFormat ?? appController.preferences.dateFormat;
    final timeFormat =
        widget.timeFormat ?? appController.preferences.timeFormat;
    final language = appController.preferences.language;

    // Use the current language locale for formatting
    final locale = '${language.code}_${language.country}';

    // Format the date and time using intl package with the selected locale
    final formattedDate =
        DateFormat(dateFormat, locale).format(_currentDateTime);
    final formattedTime =
        DateFormat(timeFormat, locale).format(_currentDateTime);

    return Text(
      widget.force2Line
          ? '$formattedDate\n$formattedTime'
          : '$formattedDate $formattedTime',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: widget.fontSize),
    );
  }
}
