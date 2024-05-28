import 'package:central_heating_control/app/core/utils/common.dart';
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
                    child: const Center(child: Text('Tab buraya')),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                        )
                    ],
                  ),
                  for (int i = 0; i < 7; i++)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                CommonUtils.dayName(i),
                                style: const TextStyle(
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
                                            const EdgeInsets.symmetric(horizontal: 1),
                                        width: 26,
                                        color: selectedDays.contains(z)
                                            ? Colors.green
                                            : (z % 2 == 0)
                                                ? Colors.transparent
                                                : Colors.grey.withOpacity(0.3),
                                        padding: const EdgeInsets.all(2),
                                        child: const Center(
                                            child: Text(
                                          '23°\nL1',
                                          style: TextStyle(fontSize: 12),
                                        )),
                                      ),
                                    )
                                  : Container(
                                      margin:
                                          const EdgeInsets.symmetric(horizontal: 1),
                                      width: 26,
                                      color: (z % 2 == 0)
                                          ? Colors.transparent
                                          : Colors.grey.withOpacity(0.3),
                                      padding: const EdgeInsets.all(2),
                                      child: const Center(
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
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                    'Selected: ${selectedDays.toString()}'),
                              ));
                            },
                            child: const Text('Edit Selected')),
                      ElevatedButton(
                        onPressed: () {
                          Get.bottomSheet(Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Copy Zone'),
                                      Text('Copy Day'),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        children: [
                                          const Text('Copy Day'),
                                          for (int i = 0; i < 7; i++)
                                            Text('Day $i'),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          const Text('Paste to'),
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
                        child: const Text('Copy Paste Options'),
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
}
