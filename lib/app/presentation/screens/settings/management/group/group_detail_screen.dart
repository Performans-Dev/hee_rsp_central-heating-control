import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/color_utils.dart';
import 'package:central_heating_control/app/core/utils/dialog_utils.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/group/group.dart';
import 'package:central_heating_control/app/presentation/widgets/common/inverted_list_tile_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/common/textfield.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class ManagementGroupDetailScreen extends StatefulWidget {
  const ManagementGroupDetailScreen({super.key, this.group});
  final GroupDefinition? group;

  @override
  State<ManagementGroupDetailScreen> createState() =>
      _ManagementGroupDetailScreenState();
}

class _ManagementGroupDetailScreenState
    extends State<ManagementGroupDetailScreen> {
  late GroupDefinition group;
  final AppController appController = Get.find();

  @override
  void initState() {
    super.initState();
    group = widget.group ?? GroupDefinition.empty();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasBackAction: true,
      title: widget.group == null ? 'Add Group'.tr : 'Edit Group'.tr,
      selectedMenuIndex: 3,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onSubmit,
        label: Text('Save'.tr),
        icon: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InvertedListTileWidget(
              title: Text('Name your group'.tr),
              subtitle: HtTextField(
                initialValue: group.name,
                onTap: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    initialValue: group.name,
                    hintText: 'Type a name for this group'.tr,
                    maxLength: 20,
                    minLength: 3,
                    type: OSKInputType.name,
                    label: 'Group name'.tr,
                  );
                  if (result != null && mounted) {
                    setState(() {
                      group = group.copyWith(name: result);
                    });
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Group color'.tr),
                  InkWell(
                    borderRadius: UiDimens.br12,
                    onTap: () {
                      DialogUtils.itemColorPickerDialog(
                          initialValue: group.color,
                          onSelected: (value) {
                            setState(() {
                              group = group.copyWith(color: value);
                            });
                          });
                    },
                    child: Container(
                      width: kToolbarHeight,
                      height: kToolbarHeight,
                      decoration: BoxDecoration(
                        borderRadius: UiDimens.br12,
                        color:
                            ColorUtils.itemColorWithValue(context, group.color),
                      ),
                      child: const Center(
                        child: Icon(Icons.edit),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.group != null)
              Container(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                    onPressed: onDelete,
                    label: Text('Delete Group'.tr),
                    icon: const Icon(Icons.delete)),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    if (widget.group == null) {
      await appController.insertGroup(group);
    } else {
      await appController.saveGroup(group);
    }
    Get.back();
  }

  Future<void> onDelete() async {
    DialogUtils.showConfirmDialog(
        context: context,
        title: 'Delete Group'.tr,
        message: 'Are you sure you want to delete this group?'.tr,
        onConfirm: () async {
          await appController.deleteGroup(group.id);
          Get.back();
        });
  }
}
