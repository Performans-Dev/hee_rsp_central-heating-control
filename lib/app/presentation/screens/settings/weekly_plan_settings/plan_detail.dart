import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/plan.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPlanDetailScreen extends StatefulWidget {
  const SettingsPlanDetailScreen({super.key});

  @override
  State<SettingsPlanDetailScreen> createState() =>
      _SettingsPlanDetailScreenState();
}

class _SettingsPlanDetailScreenState extends State<SettingsPlanDetailScreen> {
  late int planId;
  final DataController dataController = Get.find();
  late PlanDefinition plan;
  late List<PlanDetail> planDetails;
  final selectedBoxes = <String>[];
  List<PlanBy> planByList = PlanBy.values;
  List<bool> planByValues = PlanBy.values.map((e) => false).toList();

  List<int> levelList = [0, 1, 2];
  List<bool> levelValues = [true, false, false];

  int setTemperature = 22;

  @override
  void initState() {
    super.initState();
    planId = int.parse(Get.parameters['planId'] ?? '0');
    fetchData();
    planByValues.first = true;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) {
        return AppScaffold(
          selectedIndex: 3,
          title: 'Plan Detail',
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      plan.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        //TODO: show keyboard
                        /// final result= await OskKeyboard()
                        /// if (result!=null && result.isNotEmpty) {
                        /// plan.name=result;
                        /// dc.updatePlanDefinition(plan);
                        /// }
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (int z = 0; z < 24; z++)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      width: 27,
                      color: (z % 2 == 0)
                          ? Colors.transparent
                          : Colors.grey.withOpacity(0.1),
                      child: Center(
                        child: Text(
                          '0$z'.right(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              //
              for (int i = 0; i < 7; i++)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(CommonUtils.dayName(i)),
                        ),
                        for (int z = 0; z < 24; z++)
                          InkWell(
                            onTap: () {
                              final pb = '$i${'0$z'.right(2)}';
                              if (selectedBoxes.contains(pb)) {
                                setState(() {
                                  selectedBoxes.remove(pb);
                                });
                              } else {
                                setState(() {
                                  selectedBoxes.add(pb);
                                });
                              }
                              print(selectedBoxes.length);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              width: 25,
                              height: 40,
                              padding: const EdgeInsets.all(2),
                              color:
                                  selectedBoxes.contains('$i${'0$z'.right(2)}')
                                      ? Colors.greenAccent
                                      : (z % 2 == 0)
                                          ? Colors.transparent
                                          : Colors.grey.withOpacity(0.1),
                              child: Center(
                                child: planDetails.firstWhereOrNull(
                                            (e) => e.day == i && e.hour == z) !=
                                        null
                                    ? Icon(
                                        Icons.light_mode,
                                        size: 14,
                                        color: Colors.orange.withOpacity(0.83),
                                      )
                                    : Text(
                                        '-',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.2),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).highlightColor.withOpacity(0.3),
                  child: selectedBoxes.isEmpty
                      ? null
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Set Selected:"),
                            ToggleButtons(
                              isSelected: planByValues,
                              constraints: const BoxConstraints(
                                minHeight: 32.0,
                                minWidth: 96.0,
                              ),
                              borderRadius: UiDimens.formRadius,
                              onPressed: (index) {
                                planByValues =
                                    planByList.map((e) => false).toList();
                                planByValues[index] = true;
                                setState(() {});
                              },
                              children:
                                  planByList.map((e) => Text(e.name)).toList(),
                            ),
                            if (planByValues[planByList
                                .indexWhere((e) => e == PlanBy.level)])
                              ToggleButtons(
                                children:
                                    levelList.map((e) => Text('$e')).toList(),
                                isSelected: levelValues,
                                constraints: const BoxConstraints(
                                  minHeight: 32.0,
                                  minWidth: 32.0,
                                ),
                                onPressed: (index) {
                                  levelValues =
                                      levelList.map((e) => false).toList();
                                  levelValues[index] = true;
                                  setState(() {});
                                },
                                borderRadius: UiDimens.formRadius,
                              ),
                            if (planByValues[planByList
                                .indexWhere((e) => e == PlanBy.thermostate)])
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: setTemperature > 15
                                            ? () {
                                                setState(() {
                                                  setTemperature--;
                                                });
                                              }
                                            : null,
                                        icon: Icon(Icons.remove)),
                                    Text('$setTemperature°'),
                                    IconButton(
                                        onPressed: setTemperature < 35
                                            ? () {
                                                setState(() {
                                                  setTemperature++;
                                                });
                                              }
                                            : null,
                                        icon: Icon(Icons.add)),
                                  ],
                                ),
                              ),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  selectedBoxes.clear();
                                });
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (selectedBoxes.isEmpty) return;
                                final dataToSave = selectedBoxes
                                    .map((e) => PlanDetail(
                                          id: 0,
                                          planId: plan.id,
                                          hour: int.parse(e.right(2)),
                                          day: int.parse(e.left(1)),
                                          level: levelList[
                                              levelValues.indexWhere((e) => e)],
                                          degree: setTemperature,
                                          planBy: planByList[planByValues
                                              .indexWhere((e) => e)],
                                        ))
                                    .toList();
                                await dc.addPlanDetailsToDb(dataToSave);
                                selectedBoxes.clear();
                                setState(() {});
                                fetchData();
                              },
                              child: Text('SAVE'),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void fetchData() async {
    planDetails =
        dataController.planDetails.where((e) => e.planId == planId).toList();
    plan = dataController.planList.firstWhere((e) => e.id == planId);
  }
}
