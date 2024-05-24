import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DaySummaryScreen extends StatefulWidget {
  const DaySummaryScreen({super.key});

  @override
  State<DaySummaryScreen> createState() => _DaySummaryScreenState();
}

class _DaySummaryScreenState extends State<DaySummaryScreen> {
  List<int> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) {
        return GetBuilder<DataController>(
          builder: (dc) {
            return AppScaffold(
              selectedIndex: 3,
              title: 'Plan',
              body: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Theme.of(context).focusColor,
                    height: 32,
                    child: Center(child: Text('Tab buraya')),
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      for (int z = 0; z < 24; z++)
                        Container(
                          width: 28,
                          color: (z % 2 == 0)
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.3),
                          child: Center(
                              child: Text(
                            '$z',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        )
                    ],
                  ),
                  for (int i = 0; i < 7; i++)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                dayName(i),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            for (int z = 0; z < 24; z++)
                              i == 2
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedDays.contains(z)) {
                                            selectedDays.remove(z);
                                          } else {
                                            selectedDays.add(z);
                                          }
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 1),
                                        width: 26,
                                        color: selectedDays.contains(z)
                                            ? Colors.green
                                            : (z % 2 == 0)
                                                ? Colors.transparent
                                                : Colors.grey.withOpacity(0.3),
                                        padding: EdgeInsets.all(2),
                                        child: Center(
                                            child: Text(
                                          '23°\nL1',
                                          style: TextStyle(fontSize: 12),
                                        )),
                                      ),
                                    )
                                  : Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 1),
                                      width: 26,
                                      color: (z % 2 == 0)
                                          ? Colors.transparent
                                          : Colors.grey.withOpacity(0.3),
                                      padding: EdgeInsets.all(2),
                                      child: Center(
                                          child: Text(
                                        '23°\nL1',
                                        style: TextStyle(fontSize: 12),
                                      )),
                                    ),
                          ],
                        ),
                      ],
                    ),
                  Expanded(child: Container()),
                  Row(
                    children: [
                      if (selectedDays.isNotEmpty)
                        ElevatedButton(
                            onPressed: () {
                              Get.bottomSheet(Container(
                                color: Theme.of(context).canvasColor,
                                padding: EdgeInsets.all(20),
                                child: Text(
                                    'Selected: ${selectedDays.toString()}'),
                              ));
                            },
                            child: Text('Edit Selected')),
                      ElevatedButton(
                        onPressed: () {
                          Get.bottomSheet(Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Copy Zone'),
                                      Text('Copy Day'),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Text('Copy Day'),
                                          for (int i = 0; i < 7; i++)
                                            Text('Day $i'),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Text('Paste to'),
                                          for (int i = 0; i < 7; i++)
                                            Text('Day $i'),
                                        ],
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
                        },
                        child: Text('Copy Paste Options'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String dayName(int i) {
    switch (i) {
      case 0:
        return 'MON';
      case 1:
        return 'TUE';
      case 2:
        return 'WED';
      case 3:
        return 'THU';
      case 4:
        return 'FRI';
      case 5:
        return 'SAT';
      case 6:
        return 'SUN';
      default:
        return '';
    }
  }
}
