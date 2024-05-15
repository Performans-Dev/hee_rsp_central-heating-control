import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/content.dart';
import 'package:central_heating_control/app/presentation/screens/home/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsUserListScreen extends StatelessWidget {
  const SettingsUserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) => Scaffold(
        appBar: HomeAppBar(
          title: 'Settings - User List',
        ),
        body: Stack(
          children: [
            ContentWidget(
              child: ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    child: Text(app.userList[index].username.getInitials()),
                  ),
                  title: Text(app.userList[index].username),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon((app.userList[index].isAdmin)
                          ? Icons.key
                          : Icons.key_off),
                      SizedBox(width: 12),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
                itemCount: app.userList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
