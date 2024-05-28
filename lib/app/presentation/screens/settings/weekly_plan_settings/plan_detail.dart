import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPlanDetailScreen extends StatelessWidget {
  const SettingsPlanDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) {
        int planId = int.parse(Get.parameters['planId'] ?? '0');
        final data = dc.planDetails.where((e) => e.planId == planId).toList();

        return AppScaffold(
          selectedIndex: 3,
          title: 'Plan Detail',
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56,
                color: Colors.yellow,
                child: const Text('zones'),
              ),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (int z = 0; z < 24; z++)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      width: 28,
                      color: (z % 2 == 0)
                          ? Colors.transparent
                          : Colors.grey.withOpacity(0.3),
                      child: Center(
                        child: Text(
                          '$z',
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
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              width: 26,
                              height: 40,
                              padding: const EdgeInsets.all(2),
                              child: const Center(
                                child: Text(
                                  '20°',
                                  style: TextStyle(fontSize: 12),
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
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
