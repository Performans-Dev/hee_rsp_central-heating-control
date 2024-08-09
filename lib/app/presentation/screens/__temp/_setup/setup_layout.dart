/* import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupLayout extends StatelessWidget {
  const SetupLayout({
    super.key,
    required this.child,
    this.label,
    this.nextLabel,
    this.nextCallback,
    this.expandChild = false,
  });
  final Widget child;
  final String? label;
  final String? nextLabel;
  final GestureTapCallback? nextCallback;
  final bool expandChild;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      builder: (sc) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Theme.of(context).canvasColor,
              height: 64,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 12),
                    child: const LogoWidget(
                      size: 180,
                    ),
                  ),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            '$label',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        LinearProgressIndicator(
                          value: sc.progress,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: expandChild
                  ? child
                  : PiScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: child,
                    ),
            ),
            Container(
              color: Theme.of(context).canvasColor,
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 20, top: 4),
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: nextCallback,
                  child: nextLabel == null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 8),
                            Text('Next'.tr),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right),
                          ],
                        )
                      : Text(nextLabel!),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
 */