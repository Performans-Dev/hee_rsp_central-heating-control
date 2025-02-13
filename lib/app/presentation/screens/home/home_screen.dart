import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/data.dart';
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
        return GetBuilder<ChannelController>(builder: (cc) {
          return GetBuilder<DataController>(builder: (dc) {
            int length = dc.zoneList.length;
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
                        ZoneItemWidget(zone: dc.zoneList[index]),
                    itemCount: length,
                    shrinkWrap: true,
                  ),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     spacing: 12,
                  //     children: cc.outputChannels
                  //         .where((e) =>
                  //             e.deviceId == 0x00 &&
                  //             e.type == PinType.onboardPinOutput)
                  //         .map((e) => IconButton(
                  //               onPressed: () {
                  //                 final val = !e.status;
                  //                 cc.updateChannelState(e.id, val);
                  //                 cc.sendOutput2(e.pinIndex, val);
                  //               },
                  //               icon:
                  //                   Icon(e.status ? Icons.check : Icons.close),
                  //             ))
                  //         .toList(),
                  //   ),
                  // ),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Container(
                  //     color: Colors.blue.withValues(alpha: 0.2),
                  //     height: 160,
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           flex: 2,
                  //           child: ListView.builder(
                  //             itemBuilder: (context, index) => Text(
                  //               dc.runnerLogList[index],
                  //               style: const TextStyle(fontSize: 10),
                  //             ),
                  //             itemCount: math.min(dc.runnerLogList.length, 36),
                  //             shrinkWrap: true,
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 1,
                  //           child: Wrap(
                  //             children: [
                  //               Chip(
                  //                 label: const Text('1'),
                  //                 backgroundColor:
                  //                     dc.btn1 ? Colors.green : null,
                  //               ),
                  //               Chip(
                  //                 label: const Text('2'),
                  //                 backgroundColor:
                  //                     dc.btn2 ? Colors.green : null,
                  //               ),
                  //               Chip(
                  //                 label: const Text('3'),
                  //                 backgroundColor:
                  //                     dc.btn3 ? Colors.green : null,
                  //               ),
                  //               Chip(
                  //                 label: const Text('4'),
                  //                 backgroundColor:
                  //                     dc.btn4 ? Colors.green : null,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
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
        });
      },
    );
  }
}
