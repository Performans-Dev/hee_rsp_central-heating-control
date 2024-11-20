import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/process.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) {
        return GetBuilder<ProcessController>(builder: (pc) {
          int length = pc.zoneProcessList.length;
          double height = 120;
          int crossAxisCount = 3;
          if (length < 7) {
            height = 180;
          }
          if (length < 5) {
            crossAxisCount = 2;
          }

          return AppScaffold(
            body: Stack(
              children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: height,
                  ),
                  itemBuilder: (context, index) =>
                      ZoneItemWidget(id: pc.zoneProcessList[index].zone.id),
                  itemCount: length,
                  shrinkWrap: true,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text('Serial Number: ${app.deviceInfo?.serialNumber}\n'
                      'installationId: ${app.deviceInfo?.installationId}'),
                )
                // PiScrollView(
                //   child: Center(
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(vertical: 8),
                //       child:
                //           // Column(
                //           //   mainAxisSize: MainAxisSize.min,
                //           //   children: [
                //           //     Text('Zones'),
                //           //     for (final item in dc.zoneList)
                //           //       Text('${item.name} ${item.id}'),
                //           //     Divider(),
                //           //     Text('Heaters'),
                //           //     for (final item in dc.heaterList)
                //           //       Text('${item.name} ${item.id}'),
                //           //     Divider(),
                //           //     Text('Sensors'),
                //           //     for (final item in dc.sensorList)
                //           //       Text('${item.name} ${item.id}'),
                //           //     Divider(),
                //           //     Text('Ports'),
                //           //     for (final item in dc.comportList)
                //           //       Text('${item.id} ${item.title}'),
                //           //     Divider(),
                //           //   ],
                //           // ),

                //           ///////////////////

                //       //     Wrap(
                //       //   spacing: 12,
                //       //   runSpacing: 12,
                //       //   crossAxisAlignment: WrapCrossAlignment.center,
                //       //   alignment: WrapAlignment.center,
                //       //   children:
                //       //       dc.zoneList.map((e) => ZoneItem(zone: e)).toList(),
                //       // ),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        });
      },
    );
  }
}
