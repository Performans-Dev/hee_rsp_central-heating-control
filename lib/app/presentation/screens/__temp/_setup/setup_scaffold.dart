/* import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupScaffold extends StatelessWidget {
  const SetupScaffold({
    super.key,
    required this.child,
    required this.progressValue,
    this.label,
    this.nextLabel,
    this.previousLabel,
    this.nextCallback,
    this.previousCallback,
    this.expandChild = false,
  });
  final Widget child;
  final double progressValue;
  final String? label;
  final String? nextLabel;
  final String? previousLabel;
  final GestureTapCallback? nextCallback;
  final GestureTapCallback? previousCallback;
  final bool expandChild;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                        child: label == null
                            ? Text(
                                'Initial Setup'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Setup '.tr,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '$label',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      LinearProgressIndicator(
                        value: progressValue,
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
            height: 80,
            width: double.infinity,
            color: Theme.of(context).canvasColor,
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: double.infinity,
                  child: OutlinedButton(
                    onPressed: previousCallback,
                    child: previousLabel == null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.chevron_left),
                              const SizedBox(width: 8),
                              Text('Previous'.tr),
                              const SizedBox(width: 8),
                            ],
                          )
                        : Text(previousLabel!),
                  ),
                ),
                SizedBox(
                  height: double.infinity,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 */