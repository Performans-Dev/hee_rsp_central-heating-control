import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(builder: (sc) {
      return Scaffold(
        body: ListView.builder(
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
      );
    });
  }
}
