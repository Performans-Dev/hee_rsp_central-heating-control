import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/plan.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/breadcrumb.dart';
import 'package:central_heating_control/app/presentation/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SettingsPlanListScreen extends StatelessWidget {
  const SettingsPlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        selectedIndex: 3,
        title: 'Plan List',
        body: PiScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LabelWidget(text: 'Settings / Plan List'),
              ListView.builder(
                itemBuilder: (context, index) {
                  final plan = dc.planList[index];
                  if (dc.planList.isEmpty) {
                    return const Center(child: Text('Plan bulunamadı'));
                  }

                  return plan.id <= 0
                      ? Container()
                      : ListTile(
                          title: Text(plan.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OutlinedButton.icon(
                                onPressed: plan.isDefault == 1
                                    ? null
                                    : () {
                                        DialogUtils.confirmDialog(
                                          context: context,
                                          title: 'Deleting Plan',
                                          description:
                                              'Are you sure you want to delete the plan ${plan.name}',
                                          positiveText: 'Delete',
                                          negativeText: 'Cancel',
                                          positiveCallback: () {
                                            deletePlan(context, plan.id);
                                          },
                                        );
                                      },
                                icon: const Icon(Icons.delete),
                                label: Text("Delete"),
                              ),
                              OutlinedButton.icon(
                                onPressed: () async {
                                  String? newPlanName =
                                      await OnScreenKeyboard.show(
                                    context: context,
                                    hintText: "Enter new plan name",
                                    type: OSKInputType.name,
                                    minLength: 3,
                                    maxLength: 15,
                                  );

                                  if (newPlanName != null &&
                                      newPlanName.isNotEmpty) {
                                    final isDuplicate = dc.planList.any(
                                        (plan) => plan.name == newPlanName);
                                    if (isDuplicate) {
                                      if (context.mounted) {
                                        DialogUtils.snackbar(
                                          context: context,
                                          message:
                                              'A plan with this name already exists. Choose another name.',
                                          type: SnackbarType.warning,
                                        );
                                      }
                                      return;
                                    }
                                    //db bak aynı isimden varsa uyarı ver
                                    final newPlanId = await dc.copyPlan(
                                      sourcePlanId: plan.id,
                                      name: newPlanName,
                                    );
                                    if (newPlanId != null) {
                                      if (context.mounted) {
                                        DialogUtils.snackbar(
                                          context: context,
                                          message: 'Copied to new plan',
                                          type: SnackbarType.success,
                                        );
                                      }
                                      Get.toNamed(
                                        Routes.settingsPlanDetail,
                                        parameters: {
                                          'planId': newPlanId.toString(),
                                        },
                                      );
                                    } else {
                                      if (context.mounted) {
                                        DialogUtils.snackbar(
                                          context: context,
                                          message:
                                              'Could not copy plan details',
                                          type: SnackbarType.error,
                                        );
                                      }
                                    }
                                  }
                                },
                                icon: const Icon(Icons.copy),
                                label: const Text(
                                  "Copy",
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  Get.toNamed(
                                    Routes.settingsPlanDetail,
                                    parameters: {
                                      'planId': plan.id.toString(),
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit),
                                label: Text("View/Edit"),
                              ),
                            ],
                          ),
                        );
                },
                itemCount: dc.planList.length,
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      );
    });
  }

  void deletePlan(BuildContext context, int id) async {
    final DataController dataController = Get.find();
    final result = await dataController.deletePlan(planId: id);
    if (context.mounted) {
      if (result) {
        DialogUtils.snackbar(
          context: context,
          message: 'Plan deleted',
          type: SnackbarType.info,
        );
      } else {
        DialogUtils.snackbar(
          context: context,
          message: 'Could not delete plan,',
          type: SnackbarType.error,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              deletePlan(context, id);
            },
          ),
        );
      }
    }
  }
}
