import 'package:central_heating_control/app/presentation/widgets/action_button.dart';
import 'package:flutter/material.dart';

class PinResetFooterWidget extends StatelessWidget {
  final String nextLabel;
  final String prevLabel;
  final GestureTapCallback? nextAction;
  final GestureTapCallback? prevAction;
  final bool hasCancelButton;
  const PinResetFooterWidget({
    super.key,
    this.nextLabel = "Continue",
    this.prevLabel = "Back",
    this.nextAction,
    this.prevAction,
    this.hasCancelButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: !hasCancelButton
          ? Center(
              child: ActionButton(labelText: nextLabel, onPressed: nextAction),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionButton(labelText: prevLabel, onPressed: prevAction),
                ActionButton(labelText: nextLabel, onPressed: nextAction),
              ],
            ),
    );
  }
}
