import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/settings.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
import 'package:central_heating_control/app/data/models/plan.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/plan_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

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

  bool allowEdit = false;
  final selectedBoxes = <String>[];
  List<PlanBy> planByList = PlanBy.values;
  List<bool> planByValues = PlanBy.values.map((e) => false).toList();

  List<HeaterState> stateList =
      HeaterState.values.where((e) => e.index != 1).toList();
  late List<bool> selectedStateValues;
  bool selectedHasThermostat = false;
  int selectedSetTemperature = 220;
  List<PlanDetail> selectedPlanDetails = [];
  bool editedOnTheFly = false;

  @override
  void initState() {
    super.initState();
    selectedStateValues = stateList.map((e) => false).toList();
    selectedStateValues[0] = true;
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      plan.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: plan.isDefault == 1
                          ? null
                          : () async {
                              final result = await OnScreenKeyboard.show(
                                context: context,
                                label: 'Name',
                                initialValue: plan.name,
                                type: OSKInputType.name,
                              );

                              if (result != null && result.isNotEmpty) {
                                plan.name = result;
                                dc.updatePlanDefinition(plan: plan);
                              }
                            },
                      icon: const Icon(Icons.edit),
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
                            onTap: allowEdit
                                ? () => onCellTap(day: i, hour: z)
                                : null,
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
                                child: PlanIconWidget(
                                  planDetail: planDetails.firstWhereOrNull(
                                      (e) => e.day == i && e.hour == z),
                                ),
                                /*  planDetails.firstWhereOrNull(
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
                                      ), */
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).highlightColor.withOpacity(0.3),
                  child: selectedBoxes.isEmpty
                      ? null
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Set\nSelected:"),
                            const SizedBox(width: 8),
                            ToggleButtons(
                              borderRadius: UiDimens.formRadius,
                              constraints: const BoxConstraints(
                                minHeight: 32.0,
                                minWidth: 38,
                              ),
                              onPressed: (v) {
                                setState(() {
                                  for (int i = 0;
                                      i < selectedStateValues.length;
                                      i++) {
                                    selectedStateValues[i] = i == v;
                                  }
                                  editedOnTheFly = true;
                                });
                              },
                              isSelected: selectedStateValues,
                              children: stateList
                                  .map((e) => Text(CCUtils.stateDisplay(e)))
                                  .toList(),
                            ),
                            const SizedBox(width: 8),
                            ToggleButtons(
                              borderRadius: UiDimens.formRadius,
                              constraints: const BoxConstraints(
                                minHeight: 32.0,
                                minWidth: 100,
                              ),
                              onPressed: selectedStateValues.first
                                  ? null
                                  : (v) {
                                      setState(() {
                                        selectedHasThermostat =
                                            !selectedHasThermostat;
                                        editedOnTheFly = true;
                                      });
                                    },
                              isSelected: [selectedHasThermostat],
                              children: [const Text('Thermostat')],
                            ),
                            IconButton(
                                onPressed: selectedHasThermostat &&
                                        selectedSetTemperature >
                                            UiSettings.minTemperature &&
                                        !selectedStateValues.first
                                    ? () {
                                        setState(() {
                                          selectedSetTemperature -= 10;
                                          editedOnTheFly = true;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.remove)),
                            Container(
                              width: 30,
                              alignment: Alignment.center,
                              child: Text(
                                CCUtils.temperature(
                                  selectedSetTemperature,
                                  presicion: 0,
                                ),
                                style: !selectedHasThermostat ||
                                        selectedStateValues.first
                                    ? TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.color
                                            ?.withOpacity(0.4),
                                        fontStyle: FontStyle.italic,
                                      )
                                    : null,
                              ),
                            ),
                            IconButton(
                                onPressed: selectedHasThermostat &&
                                        selectedSetTemperature <
                                            UiSettings.maxTemperature &&
                                        !selectedStateValues.first
                                    ? () {
                                        setState(() {
                                          selectedSetTemperature += 10;
                                          editedOnTheFly = true;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.add)),
                            Expanded(
                              child: Container(),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  selectedBoxes.clear();
                                  editedOnTheFly = false;
                                });
                              },
                              style: const ButtonStyle(
                                padding:
                                    WidgetStatePropertyAll<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: editedOnTheFly
                                  ? () async {
                                      if (selectedBoxes.isEmpty) return;

                                      // final dataToSave = selectedBoxes
                                      //     .map((e) => PlanDetail(
                                      //           id: 0,
                                      //           planId: plan.id,
                                      //           hour: int.parse(e.right(2)),
                                      //           day: int.parse(e.left(1)),
                                      //           level: defaultLevelList[
                                      //               selectedLevelValues
                                      //                   .indexWhere((e) => e)],
                                      //           degree: selectedSetTemperature,
                                      //           planBy: planByList[planByValues
                                      //               .indexWhere((e) => e)],
                                      //         ))
                                      //     .toList();
                                      // await dc.addPlanDetailsToDb(dataToSave);
                                      // selectedBoxes.clear();
                                      // setState(() {});
                                      // fetchData();
                                    }
                                  : null,
                              style: const ButtonStyle(
                                padding:
                                    WidgetStatePropertyAll<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Text('SAVE'),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.light_mode,
                                    size: 12,
                                    color: CCUtils.colorByLevel(
                                            selectedStateValues.indexOf(true))
                                        .withOpacity(0.83),
                                  ),
                                  SizedBox(
                                    width: 24,
                                    child: Text(
                                      selectedHasThermostat
                                          ? '${(selectedSetTemperature / 10).toStringAsFixed(0)}°'
                                          : 'Lvl ${selectedStateValues.indexOf(true)}',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  )
                                ],
                              ),
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

  void onCellTap({required int day, required int hour}) {
    if (!allowEdit) {
      return;
    }

    final pb = '$day${'0$hour'.right(2)}';
    if (selectedBoxes.contains(pb)) {
      setState(() {
        selectedBoxes.remove(pb);
      });
    } else {
      setState(() {
        selectedBoxes.add(pb);
      });
    }
  }

  void fetchData() async {
    planDetails =
        dataController.planDetails.where((e) => e.planId == planId).toList();
    plan = dataController.planList.firstWhere((e) => e.id == planId);
    setState(() {
      allowEdit = plan.isDefault != 1;
    });
  }
}
