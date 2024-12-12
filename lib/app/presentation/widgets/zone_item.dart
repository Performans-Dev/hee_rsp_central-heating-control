import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/process.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/process.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_card/mode.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_card/title.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_card/warning.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneItemWidget extends StatelessWidget {
  const ZoneItemWidget({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return GetBuilder<DataController>(builder: (dc) {
        return GetBuilder<ProcessController>(builder: (pc) {
          final ZoneProcess zone =
              pc.zoneProcessList.firstWhere((e) => e.zone.id == id);
          final List<HeaterProcess> heaters =
              pc.heaterProcessList.where((e) => e.heater.zoneId == id).toList();
          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: UiDimens.formRadius),
            child: ClipRRect(
              borderRadius: UiDimens.formRadius,
              child: InkWell(
                borderRadius: UiDimens.formRadius,
                onTap: () {
                  Get.toNamed(Routes.zone, arguments: [id]);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CommonUtils.hexToColor(context, zone.zone.color)
                        .withValues(alpha: 0.3),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ZoneCardTitleWidget(
                        title: zone.zone.name,
                        subtitle:
                            '${heaters.length} Heater(s) ${(zone.hasSensor) ? ' with Sensor' : ''}',
                      ),
                      if (!heaters.every((e) => e.inputSignal))
                        const ZoneCardWarningDisplayWidget(),
                      ZoneCardModeDisplayWidget(
                        desiredState: zone.selectedState,
                        currentState: 0,
                        currentTemperature: zone.currentTemperature,
                        desiredTemperature:
                            zone.hasThermostat ? zone.desiredTemperature : null,
                        planName: dc.planList
                            .firstWhereOrNull(
                                (e) => e.id == zone.zone.selectedPlan)
                            ?.name,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      });
    });
  }
}
