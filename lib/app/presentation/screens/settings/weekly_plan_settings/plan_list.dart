import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/breadcrumb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              const BreadcrumbWidget(title: 'Settings / Plan List'),
              ListView.builder(
                itemBuilder: (context, index) {
                  final plan = dc.planList[index];
                  return plan.id <= 0
                      ? Container()
                      : ListTile(
                          title: Text(plan.name),
                          leading: Icon(
                            Icons.check,
                            color: plan.isActive == 1
                                ? Colors.green
                                : Colors.grey.withOpacity(0.3),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
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
                              ),
                              IconButton(
                                onPressed: () async {
                                  final newPlanId =
                                      await dc.copyPlan(sourcePlanId: plan.id);
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
                                            'Could not able to copy plan details',
                                        type: SnackbarType.error,
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.copy),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.toNamed(
                                    Routes.settingsPlanDetail,
                                    parameters: {
                                      'planId': plan.id.toString(),
                                    },
                                  );
                                },
                                icon: const Icon(Icons.zoom_in),
                              ),
                            ],
                          ),
                        );
                },
                itemCount: dc.planList.length,
                shrinkWrap: true,
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Add New Plan'),
                ),
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
