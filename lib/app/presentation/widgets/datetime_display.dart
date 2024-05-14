import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTextWidget extends StatefulWidget {
  const DateTextWidget({super.key, this.large = false});
  final bool large;

  @override
  State<DateTextWidget> createState() => _DateTextWidgetState();
}

class _DateTextWidgetState extends State<DateTextWidget> {
  // late String _currentDateTime;
  String formattedDate = '';
  String formattedTime = '';
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    // Update date and time every second
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDateTime();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          formattedDate,
          style: widget.large
              ? Theme.of(context).textTheme.displayLarge?.copyWith(
                  letterSpacing: 1,
                  shadows: [
                    BoxShadow(
                      color: Theme.of(context).canvasColor,
                      blurRadius: 12,
                      offset: Offset(1, 1),
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                )
              : Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(letterSpacing: 1),
        ),
        Text(
          formattedTime,
          style: widget.large
              ? Theme.of(context).textTheme.displayLarge?.copyWith(
                  shadows: [
                    BoxShadow(
                      color: Theme.of(context).canvasColor,
                      blurRadius: 12,
                      offset: Offset(1, 1),
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                )
              : Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
