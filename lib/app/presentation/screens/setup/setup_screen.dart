import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(builder: (sc) {
      final sequence =
          sc.setupSequenceList.firstWhereOrNull((e) => !e.isCompleted);
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text(sc.setupSequenceList[index].title),
                  leading: Icon(
                    sc.setupSequenceList[index].isCompleted
                        ? Icons.check
                        : Icons.close,
                  ),
                ),
                itemCount: sc.setupSequenceList.length,
              ),
            ),
            Expanded(
              flex: 5,
              child: sequence == null ? Text('none') : sequence.className,
            )
          ],
        ),
      );
    });
  }
}
