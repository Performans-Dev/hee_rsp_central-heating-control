import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/nav.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListScreen extends StatelessWidget {
  UserListScreen({super.key});
  final AppController app = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
              constraints: const BoxConstraints.expand(),
            ),
          ),
          Center(
            child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.surface,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Select user to unlock",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(
                            child: Text(
                                app.appUserList[index].username.getInitials()),
                          ),
                          title: Text(
                            app.appUserList[index].username,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white.withOpacity(0.83),
                                    ),
                          ),
                          onTap: () async {
                            var result = await Nav.toPin(
                                context: context,
                                username: app.appUserList[index].username);
                            if (result != null &&
                                app.appUserList[index].pin == result) {
                              LogService.addLog(LogDefinition(
                                  message:
                                      "${app.appUserList[index].username} unlocked"));
                              NavController.toHome();
                            }
                          },
                        ),
                        itemCount: app.appUserList.length,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}



































/*            */