import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) {
        return GetBuilder<DataController>(builder: (dc) {
          return AppScaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Zones'),
                          for (final item in dc.zoneList)
                            Text('${item.name} ${item.id}'),
                          Divider(),
                          Text('Heaters'),
                          for (final item in dc.heaterList)
                            Text('${item.name} ${item.id}'),
                          Divider(),
                          Text('Sensors'),
                          for (final item in dc.sensorList)
                            Text('${item.name} ${item.id}'),
                          Divider(),
                          Text('Ports'),
                          for (final item in dc.comportList)
                            Text('${item.id} ${item.title}'),
                          Divider(),
                        ],
                      ),
                      // Wrap(
                      //   spacing: 12,
                      //   runSpacing: 12,
                      //   crossAxisAlignment: WrapCrossAlignment.center,
                      //   alignment: WrapAlignment.center,
                      //   children: [
                      //     for (int i = 0; i < 17; i++) zonePlaceholder(i),
                      //   ],
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget zonePlaceholder(int i) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 210,
            height: 160,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Zone A'),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Switch(
                      value: i % 2 == 0,
                      onChanged: (value) {},
                    ),
                  ),
                ),
                (i % 3 == 0)
                    ? Text('23.${i % 2} °C')
                    : const Icon(Icons.warning),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
