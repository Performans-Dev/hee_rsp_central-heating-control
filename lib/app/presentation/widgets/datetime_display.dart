import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTextWidget extends StatefulWidget {
  const DateTextWidget({super.key});

  @override
  State<DateTextWidget> createState() => _DateTextWidgetState();
}

class _DateTextWidgetState extends State<DateTextWidget> {
  // late String _currentDateTime;
  String formattedDate = '';
  String formattedTime = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    // Update date and time every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDateTime();
    });
  }

  void _updateDateTime() {
    setState(() {
      DateTime now = DateTime.now();
      formattedDate = DateFormat.yMd().format(now);
      formattedTime = DateFormat.Hms().format(now);
      // _currentDateTime = '$formattedDate\n$formattedTime';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formattedDate,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          formattedTime,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
