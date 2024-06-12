import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
import 'package:central_heating_control/app/data/models/plan.dart';
import 'package:flutter/material.dart';

class PlanIconWidget extends StatelessWidget {
  const PlanIconWidget({super.key, required this.planDetail});
  final PlanDetail? planDetail;

  @override
  Widget build(BuildContext context) {
    if (planDetail == null) {
      return Text(
        '-',
        style: TextStyle(
          fontSize: 12,
          color:
              Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.2),
        ),
      );
    } else {
      Widget icon = const SizedBox();
      if (planDetail!.level == 0) {
        icon = Text('off');
      } else {
        icon = Icon(
          Icons.light_mode,
          size: 14,
          color: CCUtils.colorByLevel(planDetail!.level).withOpacity(0.83),
        );
      }

      if (planDetail!.planBy == PlanBy.thermostat) {
        return Stack(
          children: [
            icon,
            Text(CCUtils.temperature(planDetail!.degree)),
          ],
        );
      } else {
        return icon;
      }
    }
  }
}
