import 'package:central_heating_control/app/data/controllers/app_user.dart';
import 'package:central_heating_control/app/data/models/app_user/app_user.dart';
import 'package:central_heating_control/app/presentation/widgets/common/inverted_list_tile_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/common/user_dropdown.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class AddNewAppUserScreen extends StatefulWidget {
  const AddNewAppUserScreen({super.key});

  @override
  State<AddNewAppUserScreen> createState() => _AddNewAppUserScreenState();
}

class _AddNewAppUserScreenState extends State<AddNewAppUserScreen> {
  AppUser appUser = AppUser(id: -1, name: '', pinCode: '', level: 0);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUserController>(builder: (auc) {
      return AppScaffold(
        title: 'Add New User'.tr,
        hasBackAction: true,
        selectedMenuIndex: 1,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InvertedListTileWidget(
                title: Text('User Name'.tr),
                subtitle: Text(appUser.name),
                onTap: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    initialValue: appUser.name,
                    minLength: 3,
                    maxLength: 12,
                    type: OSKInputType.name,
                    label: 'User Name'.tr,
                    hintText: 'Enter User Name'.tr,
                  );
                  if (result != null) {
                    final au = appUser.copyWith(name: result);
                    setState(() {
                      appUser = au;
                    });
                  }
                },
              ),
              InvertedListTileWidget(
                title: Text('Pin Code'.tr),
                subtitle:
                    Text(appUser.pinCode.replaceAll(RegExp(r'\d'), ' * ')),
                onTap: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    initialValue: appUser.pinCode,
                    minLength: 6,
                    maxLength: 6,
                    type: OSKInputType.number,
                    label: 'Pin Code'.tr,
                    hintText: 'Enter Pin Code'.tr,
                  );
                  if (result != null) {
                    final au = appUser.copyWith(pinCode: result);
                    setState(() {
                      appUser = au;
                    });
                  }
                },
              ),
              InvertedListTileWidget(
                title: Text('Level'.tr),
                subtitle: AppUserLevelDropdownWidget(
                  onSelected: (v) {
                    final au = appUser.copyWith(level: v!);
                    setState(() {
                      appUser = au;
                    });
                  },
                  initialValue: appUser.level,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: appUser.isValid ? null : 0,
          onPressed: appUser.isValid ? () async {} : null,
          label: Text('Save'.tr),
          icon: const Icon(Icons.save),
        ),
      );
    });
  }
}
