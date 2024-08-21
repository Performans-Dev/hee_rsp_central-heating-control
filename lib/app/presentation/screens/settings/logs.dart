import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/day.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/month.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/year.dart';
import 'package:intl/intl.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogViewScreen extends StatefulWidget {
  const LogViewScreen({super.key});

  @override
  State<LogViewScreen> createState() => _LogViewScreenState();
}

class _LogViewScreenState extends State<LogViewScreen> {
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;
  List<int> availableYears = [];
  List<int> availableMonths = List.generate(12, (index) => index + 1);
  List<int> availableDays = [];
  List<LogDefinition> logs = [];

  @override
  void initState() {
    super.initState();
    _initializeDateDropdowns();
  }

  void _initializeDateDropdowns() {
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
    selectedDay = now.day;

    // Populate availableYears based on your log data
    availableYears = [
      now.year
    ]; // This should be dynamically loaded based on available logs

    _loadLogsForSelectedDate();
  }

  void _loadLogsForSelectedDate() async {
    DateTime selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
    List<LogDefinition> fetchedLogs =
        await LogService.readLogs(date: selectedDate);
    setState(() {
      logs = fetchedLogs;
      availableDays = List.generate(
        DateTime(selectedYear, selectedMonth + 1, 0).day,
        (index) => index + 1,
      );
    });
  }

  void _selectToday() {
    final now = DateTime.now();
    setState(() {
      selectedYear = now.year;
      selectedMonth = now.month;
      selectedDay = now.day;
      _loadLogsForSelectedDate();
    });
  }

  void _previousDay() {
    final date = DateTime(selectedYear, selectedMonth, selectedDay)
        .subtract(const Duration(days: 1));
    setState(() {
      selectedYear = date.year;
      selectedMonth = date.month;
      selectedDay = date.day;
      _loadLogsForSelectedDate();
    });
  }

  void _nextDay() {
    final date = DateTime(selectedYear, selectedMonth, selectedDay)
        .add(const Duration(days: 1));
    setState(() {
      selectedYear = date.year;
      selectedMonth = date.month;
      selectedDay = date.day;
      _loadLogsForSelectedDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 3,
      title: 'Logs'.tr,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Year Dropdown
                SizedBox(
                  width: 80,
                  child: YearDropdownWidget(
                    value: selectedYear,
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value!;
                        _loadLogsForSelectedDate();
                      });
                    },
                    items: availableYears,
                  ),
                ),
                SizedBox(width: 8),
                // Month Dropdown
                SizedBox(
                  width: 128,
                  child: MonthDropdownWidget(
                    value: selectedMonth,
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value!;
                        _loadLogsForSelectedDate();
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                // Day Dropdown
                SizedBox(
                  width: 60,
                  child: DayDropdownWidget(
                    value: selectedDay,
                    onChanged: (value) {
                      setState(() {
                        selectedDay = value!;
                        _loadLogsForSelectedDate();
                      });
                    },
                  ),
                ),
                Expanded(child: Container()),
                // "Today" Button
                IconButton(
                    onPressed: _previousDay, icon: Icon(Icons.chevron_left)),
                TextButton.icon(
                  onPressed: selectedDay == DateTime.now().day &&
                          selectedMonth == DateTime.now().month &&
                          selectedYear == DateTime.now().year
                      ? null
                      : _selectToday,
                  label: Text('Show Today'.tr),
                  icon: Icon(Icons.today),
                ),
                IconButton(
                    onPressed: _nextDay, icon: Icon(Icons.chevron_right)),
                SizedBox(width: 8),
                TextButton.icon(
                  onPressed: logs.isEmpty ? null : () {},
                  label: Text('Sync'.tr),
                  icon: Icon(Icons.sync),
                ),
              ],
            ),
          ),
          Expanded(
            child: logs.isEmpty
                ? Center(
                    child: Text('No logs found'),
                  )
                : ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return ListTile(
                        title: Text(log.message),
                        subtitle: Text('${log.level} - ${log.time}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
