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
              Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.2),
        ),
      );
    } else {
      Widget icon = const SizedBox();
      if (planDetail!.level == 0) {
        icon = Text(
          '-',
          style: TextStyle(
            fontSize: 12,
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.2),
          ),
        );
      } else {
        icon = Icon(
          Icons.light_mode,
          size: 14,
          color: CCUtils.colorByLevel(planDetail!.level).withValues(alpha: 0.83),
        );
      }

      if (planDetail!.hasThermostat == 1) {
        return Stack(
          children: [
            icon,
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                CCUtils.temperature(planDetail!.degree, presicion: 0),
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        );
      } else {
        return icon;
      }
    }
  }
}
