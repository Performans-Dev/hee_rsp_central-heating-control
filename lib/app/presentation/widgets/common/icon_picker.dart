import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconPickerWidget extends StatelessWidget {
  const IconPickerWidget(
      {super.key,
      this.initialValue,
      required this.iconList,
      required this.onSelected});
  final String? initialValue;
  final List<String> iconList;
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: UiDimens.br12,
        border: Border.all(
            color: Theme.of(context)
                    .inputDecorationTheme
                    .border
                    ?.borderSide
                    .color ??
                Theme.of(context).colorScheme.onSurface),
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: iconList
            .map((e) => initialValue == e
                ? Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: UiDimens.br12,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                          style: BorderStyle.solid,
                        )),
                    child: Center(
                      child: SvgPicture.network(
                        e,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  )
                : IconButton(
                    disabledColor: Colors.red,
                    icon: SvgPicture.network(
                      e,
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      onSelected(e);
                    },
                  ))
            .toList(),
      ),
    );
  }
}
