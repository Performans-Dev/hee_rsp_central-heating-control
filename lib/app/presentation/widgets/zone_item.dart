import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/zone.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/screens/zone/zone_screen.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_card/mode.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_card/title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneItemWidget extends StatelessWidget {
  const ZoneItemWidget({super.key, required this.zone});
  final Zone zone;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return GetBuilder<DataController>(builder: (dc) {
        return Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: UiDimens.formRadius),
          child: ClipRRect(
            borderRadius: UiDimens.formRadius,
            child: InkWell(
              borderRadius: UiDimens.formRadius,
              onTap: () {
                Get.to(() => ZoneScreen(
                      zone: zone,
                    ));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CommonUtils.hexToColor(context, zone.color)
                      .withValues(alpha: 0.3),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ZoneCardTitleWidget(
                      title: zone.name,
                      subtitle: 'TODO: ',
                      // '${heaters.length} Heater(s) ${(zone.hasSensor) ? ' with Sensor' : ''}',
                    ),
                    // if (!heaters.every((e) => e.inputSignal))
                    //   const ZoneCardWarningDisplayWidget(),
                    ZoneCardModeDisplayWidget(
                      desiredMode: zone.desiredMode,
                      currentMode: zone.currentMode,
                      currentTemperature: zone.currentTemperature?.toInt(),
                      desiredTemperature: zone.hasThermostat
                          ? zone.desiredTemperature?.toInt()
                          : null,
                      planName: dc.planList
                          .firstWhereOrNull((e) => e.id == zone.selectedPlan)
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
  }
}
