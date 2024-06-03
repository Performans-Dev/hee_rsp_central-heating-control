import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:flutter/material.dart';

class ZoneItem extends StatelessWidget {
  const ZoneItem({super.key, required this.zone});
  final ZoneDefinition zone;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: UiDimens.formRadius),
      child: ClipRRect(
        borderRadius: UiDimens.formRadius,
        child: InkWell(
          borderRadius: UiDimens.formRadius,
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  CommonUtils.hexToColor(context, zone.color).withOpacity(0.3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        zone.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '23.4°',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.warning),
                    Switch(
                      value: false,
                      onChanged: (v) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
