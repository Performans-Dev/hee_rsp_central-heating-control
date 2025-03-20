import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSidebarWidget extends StatelessWidget {
  const SetupSidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: GetBuilder<SetupController>(
        builder: (sc) {
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text(sc.setupSequenceList[index].title),
            ),
            itemCount: sc.setupSequenceList.length,
          );
        },
      ),
    );
  }
}
