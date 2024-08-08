import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/string.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:central_heating_control/app/presentation/screens/__temp/_setup/setup_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequenceDateFormatSection extends StatefulWidget {
  const SetupSequenceDateFormatSection({super.key});

  @override
  State<SetupSequenceDateFormatSection> createState() =>
      _SetupSequenceDateFormatSectionState();
}

class _SetupSequenceDateFormatSectionState
    extends State<SetupSequenceDateFormatSection> {
  final AppController appController = Get.find();
  late String _selectedDateFormat;
  late String _selectedTimeFormat;

  @override
  void initState() {
    super.initState();
    _selectedDateFormat = Box.getString(
      key: Keys.selectedDateFormat,
      defaultVal: appController.dateFormats.first,
    );
    _selectedTimeFormat = Box.getString(
      key: Keys.selectedTimeFormat,
      defaultVal: appController.timeFormats.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      builder: (sc) {
        return GetBuilder<AppController>(
          builder: (app) {
            return SetupScaffold(
              progressValue: sc.progress,
              label: 'Date Format'.tr,
              nextCallback: () async {
                Buzz.feedback();
                //save dateformat
                await Box.setString(
                    key: Keys.selectedDateFormat, value: _selectedDateFormat);
                //save timeformat
                await Box.setString(
                    key: Keys.selectedTimeFormat, value: _selectedTimeFormat);
                await Box.setBool(key: Keys.didDateFormatSelected, value: true);

                sc.refreshSetupSequenceList();
                NavController.toHome();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Choose a Date Time Format'.tr,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: FormItemComponent(
                          label: 'Date Format',
                          child: StringDropdownWidget(
                            data: app.dateFormats,
                            value: _selectedDateFormat,
                            onChanged: (v) {
                              Buzz.feedback();

                              if (v == null) return;
                              setState(() => _selectedDateFormat = v);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FormItemComponent(
                          label: 'Time Format',
                          child: StringDropdownWidget(
                            data: app.timeFormats,
                            value: _selectedTimeFormat,
                            onChanged: (v) {
                              Buzz.feedback();
                              if (v == null) return;
                              setState(() => _selectedTimeFormat = v);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FormItemComponent(
                          label: 'Preview',
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.3),
                              borderRadius: UiDimens.formRadius,
                            ),
                            child: DateTextWidget(
                              dateFormat: _selectedDateFormat,
                              timeFormat: _selectedTimeFormat,
                              oneLine: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
