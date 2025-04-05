import 'package:central_heating_control/app/data/controllers/input_output.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_output.dart';
import 'package:central_heating_control/app/presentation/widgets/common/card_button_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class AdvancedScreen extends StatelessWidget {
  const AdvancedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IOController>(builder: (ioc) {
      return AppScaffold(
        title: 'Advanced'.tr,
        hasBackAction: true,
        selectedMenuIndex: 1,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ...ioc.digitalOutputs.map((e) => CardButtonWidget(
                    title: e.name,
                    subtitle: 'hw:${e.hwId} - pin:${e.pinIndex}',
                    icon: Icons.output,
                    size: CardSize.mini,
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () async {
                      final result = await OnScreenKeyboard.show(
                        context: context,
                        initialValue: e.name,
                        label: 'Digital Output Name [${e.pinIndex}]',
                        maxLength: 12,
                        minLength: 2,
                        type: OSKInputType.name,
                      );
                      if (result != null) {
                        final newDigitalOutput = e.copyWith(name: result);
                        await ioc.saveDigitalOutput(newDigitalOutput);
                      }
                    },
                  )),
              ...ioc.digitalInputs.map((e) => CardButtonWidget(
                    title: e.name,
                    subtitle: 'hw:${e.hwId} - pin:${e.pinIndex}',
                    icon: Icons.input,
                    size: CardSize.mini,
                    color: Theme.of(context).colorScheme.secondary,
                    onTap: () async {
                      final result = await OnScreenKeyboard.show(
                        context: context,
                        initialValue: e.name,
                        label: 'Digital Input Name [${e.pinIndex}]',
                        maxLength: 12,
                        minLength: 2,
                        type: OSKInputType.name,
                      );
                      if (result != null) {
                        final newDigitalInput = e.copyWith(name: result);
                        await ioc.saveDigitalInput(newDigitalInput);
                      }
                    },
                  )),
              ...ioc.analogInputs.map((e) => CardButtonWidget(
                    title: e.name,
                    subtitle: 'hw:${e.hwId} - pin:${e.pinIndex} - t:${e.type}',
                    icon: Icons.sensors,
                    size: CardSize.small,
                    color: Theme.of(context).colorScheme.tertiary,
                    onTap: () async {
                      final result = await OnScreenKeyboard.show(
                        context: context,
                        initialValue: e.name,
                        label: 'Analog Input Name [${e.pinIndex}]',
                        maxLength: 12,
                        minLength: 2,
                        type: OSKInputType.name,
                      );
                      if (result != null) {
                        final newAnalogInput = e.copyWith(name: result);
                        await ioc.saveAnalogInput(newAnalogInput);
                      }
                    },
                  )),
            ],
          ),
        ),
      );
    });
  }
}
