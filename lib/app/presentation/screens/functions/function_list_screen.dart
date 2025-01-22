import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FunctionListScreen extends StatelessWidget {
  const FunctionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        selectedIndex: 1,
        title: 'Functions'.tr,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.sunny,
                    color: dc.btn1 ? Colors.green : null,
                  ),
                  title: const Text('F1'),
                  trailing: const Text('dropdown here'),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.sunny,
                    color: dc.btn2 ? Colors.green : null,
                  ),
                  title: const Text('F2'),
                  trailing: const Text('dropdown here'),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.sunny,
                    color: dc.btn3 ? Colors.green : null,
                  ),
                  title: const Text('F3'),
                  trailing: const Text('dropdown here'),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.sunny,
                    color: dc.btn4 ? Colors.green : null,
                  ),
                  title: const Text('F4'),
                  trailing: const Text('dropdown here'),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
