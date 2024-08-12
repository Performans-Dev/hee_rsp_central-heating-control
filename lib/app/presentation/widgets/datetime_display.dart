import 'dart:async';

import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateTextWidget extends StatefulWidget {
  const DateTextWidget({
    super.key,
    this.large = false,
    this.oneLine = false,
    this.dateFormat,
    this.timeFormat,
  });
  final bool large;
  final bool oneLine;
  final String? dateFormat;
  final String? timeFormat;

  @override
  State<DateTextWidget> createState() => _DateTextWidgetState();
}

class _DateTextWidgetState extends State<DateTextWidget> {
  final AppController appController = Get.find();
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

  /// Updates the current date and time and formats it accordingly.
  ///
  /// This function retrieves the current date and time using `DateTime.now()`
  /// and formats it using the `DateFormat` class. The formatted date and time
  /// are then stored in the `formattedDate` and `formattedTime` variables.
  ///
  /// If the `large` property of the `widget` is `true`, the date is formatted
  /// as "d MMMM\nEEEE", otherwise it is formatted as "d MMM, E". The time is
  /// always formatted as "HH:mm:ss".
  ///
  /// This function does not return any value.
  void _updateDateTime() {
    String df = widget.dateFormat ?? appController.dateFormats.last;
    String tf = widget.timeFormat ?? appController.timeFormats[2];

    setState(() {
      DateTime now = DateTime.now();
      formattedDate = widget.oneLine
          ? DateFormat('$df $tf').format(now)
          : DateFormat(df).format(now);
      formattedTime = DateFormat(tf).format(now);
      // _currentDateTime = '$formattedDate\n$formattedTime';
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.oneLine
        ? Text(formattedDate)
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formattedDate,
                textAlign: TextAlign.center,
                style: widget.large
                    ? Theme.of(context).textTheme.displayMedium?.copyWith(
                        letterSpacing: 1,
                        color: Colors.white.withOpacity(0.83),
                        shadows: [
                          BoxShadow(
                            color: Theme.of(context).canvasColor,
                            blurRadius: 12,
                            offset: const Offset(1, 1),
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      )
                    : Theme.of(context).textTheme.bodySmall?.copyWith(
                          letterSpacing: 1,
                        ),
              ),
              Text(
                formattedTime,
                style: widget.large
                    ? Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white.withOpacity(0.83),
                        shadows: [
                          BoxShadow(
                            color: Theme.of(context).canvasColor,
                            blurRadius: 12,
                            offset: const Offset(1, 1),
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
