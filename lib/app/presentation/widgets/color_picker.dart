import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:flutter/material.dart';

class ColorPickerWidget extends StatelessWidget {
  const ColorPickerWidget({
    super.key,
    this.selectedValue,
    required this.onSelected,
  });
  final String? selectedValue;
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: UiData.colorList
          .map((e) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    onSelected(e);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color:
                          CommonUtils.hexToColor(context, e).withOpacity(0.3),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        selectedValue == e
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
