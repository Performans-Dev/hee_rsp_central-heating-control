import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChannelDropdownWidget extends StatelessWidget {
  const ChannelDropdownWidget({
    super.key,
    this.onChanged,
    this.group,
    this.value,
  });
  final Function(int?)? onChanged;
  final GpioGroup? group;
  final int? value;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChannelController>(builder: (cc) {
      return GetBuilder<DataController>(builder: (dc) {
        final List<ChannelDefinition> data = group == GpioGroup.outPin
            ? cc.outputChannels.where((e) => e.userSelectable).toList()
            : group == GpioGroup.inPin
                ? cc.inputChannels.where((e) => e.userSelectable).toList()
                : [];
        final occupiedIds = [3, 5];
        var selectedValue = value;
        selectedValue ??= data.first.id;

        return ClipRRect(
          borderRadius: UiDimens.formRadius,
          child: DropdownButton<int>(
            underline: Container(),
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            items: data.map((e) {
              bool own = e.id == value;
              return DropdownMenuItem<int>(
                value: e.id,
                enabled: !occupiedIds.contains(e.id) && !own,
                child: Text(e.name),
              );
            }).toList(),
            onChanged: onChanged,
            value: value,
            borderRadius: UiDimens.formRadius,
          ),
        );
        /*  final l1List = dc.heaterList
              .map((e) => e.outputChannel1)
              .where((e) => e != null)
              .toList();
          final l2List = dc.heaterList
              .map((e) => e.level2Relay)
              .where((e) => e != null)
              .toList();
          final usedInChannels = dc.heaterList
              .map((e) => e.errorChannel)
              .where((e) => e != null)
              .toList();
          final usedOutChannels = [...l1List, ...l2List];¬
        
          final data = UiData.getChannelsDropdown(group);
          var selectedValue = value;
          selectedValue ??= data.first;
        
          return ClipRRect(
            borderRadius: UiDimens.formRadius,
            child: DropdownButton<Channel>(
              underline: Container(), isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              items: data.map((e) {
                bool isUsed = group == GpioGroup.outPin
                    ? usedOutChannels.map((c) => c?.id).toList().contains(e.id)
                    : usedInChannels.map((c) => c?.id).toList().contains(e.id);
                bool own = e.id == value?.id;
                return DropdownMenuItem<Channel>(
                  value: e,
                  enabled: own ? true : !isUsed,
                  child: Text(
                    '${e.name.camelCaseToHumanReadable()} ',
                    style: TextStyle(
                      color: own
                          ? Colors.green
                          : !isUsed
                              ? null
                              : Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.4),
                      fontStyle:
                          !own && isUsed ? FontStyle.italic : FontStyle.normal,
                      fontWeight: own ? FontWeight.bold : null,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              value: selectedValue,
              borderRadius: UiDimens.formRadius,
              // decoration: InputDecoration(border: UiDimens.formBorder),
            ),
          ); */
      });
    });
  }
}
