import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanDropdownWidget extends StatelessWidget {
  const PlanDropdownWidget({
    super.key,
    this.onChanged,
    this.value,
  });
  final Function(int?)? onChanged;
  final int? value;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return ClipRRect(
        borderRadius: UiDimens.formRadius,
        child: DropdownButton<int?>(
          underline: Container(),
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          onChanged: onChanged,
          value: value,
          borderRadius: UiDimens.formRadius,
          items: dc.planList
              .map((e) => DropdownMenuItem<int?>(
                    value: e.id,
                    child: Text(e.name),
                  ))
              .toList(),
        ),
      );
    });
  }
}
