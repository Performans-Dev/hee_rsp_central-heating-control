import 'package:central_heating_control/app/core/utils/osk/enum.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";

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
                          const Text("Username"),
                          InkWell(
                            onTap: () async {
                              final result = await Get.toNamed(
                                  Routes.onScreenKeyboard,
                                  parameters: {
                                    "initialValue": userName,
                                    "label": "Username",
                                    "inputType":
                                        OnScreenKeyboardInputType.name.name,
                                  });
                              if (result != null) {
                                setState(() {
                                  userName = result;
                                });
                              }
                            },
                            child: Container(
                              color: Colors.blueAccent,
                              width: double.infinity,
                              child: Text(userName.isEmpty
                                  ? "Enter Username"
                                  : userName),
                            ),
                          )
                        ],
                      ),
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
