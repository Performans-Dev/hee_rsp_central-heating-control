import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_card/heater.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_card/sensor.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_card/shutdown.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_card/title.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_card/warning.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneItem extends StatelessWidget {
  const ZoneItem({super.key, required this.zone});
  final ZoneDefinition zone;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      final List<HeaterDevice> heaters =
          dc.heaterList.where((e) => e.zoneId == zone.id).toList();
      final List<SensorDevice> sensors =
          dc.sensorList.where((e) => e.zoneId == zone.id).toList();
      final bool hasWarning = true;
      return Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: UiDimens.formRadius),
        child: ClipRRect(
          borderRadius: UiDimens.formRadius,
          child: InkWell(
            borderRadius: UiDimens.formRadius,
            onTap: () {
              Get.toNamed(Routes.zone, arguments: [zone]);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CommonUtils.hexToColor(context, zone.color)
                    .withOpacity(0.3),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ZoneCardTitleWidget(title: zone.name),
                  if (sensors.isNotEmpty)
                    ZoneCardSensorDisplayWidget(
                      sensors: sensors,
                    ),
                  if (heaters.isNotEmpty)
                    ZoneCardHeaterDisplayWidget(
                      heaters: heaters,
                    ),
                  if (hasWarning) ZoneCardWarningDisplayWidget(),
                  if (heaters.isNotEmpty)
                    ZoneCardHeaterShutdownWidget(
                      heaters: heaters,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
