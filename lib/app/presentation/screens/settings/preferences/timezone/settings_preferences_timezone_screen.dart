import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/day.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/hour.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/minute.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/month.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/string.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/timezone.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/year.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesTimezoneScreen extends StatefulWidget {
  const SettingsPreferencesTimezoneScreen({super.key});

  @override
  State<SettingsPreferencesTimezoneScreen> createState() =>
      _SettingsPreferencesTimezoneScreenState();
}

class _SettingsPreferencesTimezoneScreenState
    extends State<SettingsPreferencesTimezoneScreen> {
  late TimezoneDefinition _selectedTimezone;
  bool ready = true;
  AppController app = Get.find();
  List<TimezoneDefinition> timezones = [];
  bool didDateTimeChanged = false;
  bool didTimezoneChanged = false;

  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  late int _selectedHour;
  late int _selectedMinute;
  late String _selectedDateFormat;
  late String _selectedTimeFormat;

  @override
  void initState() {
    super.initState();
    _selectedTimezone = app.timezones.firstWhereOrNull((e) =>
            e.zone ==
            (TimezoneDefinition.fromJson(
                    Box.getString(key: Keys.selectedTimezone)))
                .zone) ??
        app.timezones.first;
    _selectedYear = DateTime.now().year;
    _selectedMonth = DateTime.now().month;
    _selectedDay = DateTime.now().day;
    _selectedHour = DateTime.now().hour;
    _selectedMinute = DateTime.now().minute;
    _selectedDateFormat = Box.getString(
        key: Keys.selectedDateFormat, defaultVal: app.dateFormats.first);
    _selectedTimeFormat = Box.getString(
        key: Keys.selectedTimeFormat, defaultVal: app.timeFormats.first);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (ac) {
        return AppScaffold(
          title: 'Date, Time and Timezone',
          selectedIndex: 3,
          body: ready
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // const BreadcrumbWidget(
                    //   title: 'Settings / Preferences / Date, Time and Timezone',
                    // ),
                    Expanded(
                      child: PiScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormItemComponent(
                              label: 'Change Date-Time',
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: FormItemComponent(
                                      label: 'Year',
                                      child: YearDropdownWidget(
                                        value: _selectedYear,
                                        onChanged: (value) {
                                          if (value == null) return;
                                          setState(() {
                                            _selectedYear = value;
                                            didDateTimeChanged = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: FormItemComponent(
                                      label: 'Month',
                                      child: MonthDropdownWidget(
                                        value: _selectedMonth,
                                        onChanged: (value) {
                                          if (value == null) return;
                                          setState(() {
                                            _selectedMonth = value;
                                            didDateTimeChanged = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: FormItemComponent(
                                      label: 'Day',
                                      child: DayDropdownWidget(
                                        value: _selectedDay,
                                        onChanged: (value) {
                                          if (value == null) return;
                                          setState(() {
                                            _selectedDay = value;
                                            didDateTimeChanged = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: FormItemComponent(
                                      label: 'Hour',
                                      child: HourDropdownWidget(
                                        value: _selectedHour,
                                        onChanged: (value) {
                                          if (value == null) return;
                                          setState(() {
                                            _selectedHour = value;
                                            didDateTimeChanged = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: FormItemComponent(
                                      label: 'Minute',
                                      child: MinuteDropdownWidget(
                                        value: _selectedMinute,
                                        onChanged: (value) {
                                          if (value == null) return;
                                          setState(() {
                                            _selectedMinute = value;
                                            didDateTimeChanged = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            FormItemComponent(
                              label: 'Display Date Time',
                              child: Row(
                                children: [
                                  Expanded(
                                    child: FormItemComponent(
                                      label: 'Date Format',
                                      child: StringDropdownWidget(
                                        data: app.dateFormats,
                                        value: _selectedDateFormat,
                                        onChanged: (v) {
                                          if (v == null) return;
                                          setState(
                                              () => _selectedDateFormat = v);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: FormItemComponent(
                                      label: 'Time Format',
                                      child: StringDropdownWidget(
                                        data: app.timeFormats,
                                        value: _selectedTimeFormat,
                                        onChanged: (v) {
                                          if (v == null) return;
                                          setState(
                                              () => _selectedTimeFormat = v);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: FormItemComponent(
                                      label: 'Preview',
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.3),
                                          borderRadius: UiDimens.formRadius,
                                        ),
                                        child: DateTextWidget(
                                          dateFormat: _selectedDateFormat,
                                          timeFormat: _selectedTimeFormat,
                                          oneLine: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            FormItemComponent(
                              label: 'Timezone',
                              child: ac.timezones.isEmpty
                                  ? const CircularProgressIndicator()
                                  : TimezoneDropdownWidget(
                                      data: app.timezones,
                                      value: _selectedTimezone,
                                      onChanged: (v) {
                                        if (v == null) return;
                                        setState(() {
                                          _selectedTimezone = v;
                                          didTimezoneChanged = true;
                                        });
                                      },
                                    ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    actionButton,
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget get actionButton => Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancel")),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                //save selected timezone
                await Box.setString(
                  key: Keys.selectedTimezone,
                  value: _selectedTimezone.toJson(),
                );
                //save dateformat
                await Box.setString(
                    key: Keys.selectedDateFormat, value: _selectedDateFormat);
                //save timeformat
                await Box.setString(
                    key: Keys.selectedTimeFormat, value: _selectedTimeFormat);

                // inform OS if necessary
                if (didDateTimeChanged && didTimezoneChanged) {
                  var newTime = DateTime(_selectedYear, _selectedMonth,
                      _selectedDay, _selectedHour, _selectedMinute);
                  Duration offset = _selectedTimezone.offset();
                  var utcTime = newTime.subtract(offset);
                  //TODO: save utc time in OS
                  print(utcTime);
                  //TODO: save timezone in OS
                  print(_selectedTimezone.zone);
                } else if (didDateTimeChanged && !didTimezoneChanged) {
                  var newTime = DateTime(_selectedYear, _selectedMonth,
                      _selectedDay, _selectedHour, _selectedMinute);
                  //TODO: save local time in OS
                  print(newTime);
                } else if (!didDateTimeChanged && didTimezoneChanged) {
                  //TODO: save only timezone in OS
                  print(_selectedTimezone.zone);
                }

                if (mounted) {
                  DialogUtils.snackbar(
                    context: context,
                    message: 'Changes Saved successfully',
                    type: SnackbarType.info,
                  );
                }

                Get.back();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );
}
