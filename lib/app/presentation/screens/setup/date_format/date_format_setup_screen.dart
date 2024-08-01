import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/gpio.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/string.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupDateFormatScreen extends StatefulWidget {
  const SetupDateFormatScreen({super.key});

  @override
  State<SetupDateFormatScreen> createState() => _SetupDateFormatScreenState();
}

class _SetupDateFormatScreenState extends State<SetupDateFormatScreen> {
  late String _selectedDateFormat;
  late String _selectedTimeFormat;

  @override
  void initState() {
    super.initState();
    _selectedDateFormat = Box.getString(
      key: Keys.selectedDateFormat,
      defaultVal: UiData.dateFormats.first,
    );
    _selectedTimeFormat = Box.getString(
      key: Keys.selectedTimeFormat,
      defaultVal: UiData.timeFormats.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) {
        return SetupScaffold(
          label: 'Date Format'.tr,
          previousCallback: () {
            Get.toNamed(Routes.setupTimezone);
          },
          nextCallback: () async {
            Buzz.feedback();
            //save dateformat
            await Box.setString(
                key: Keys.selectedDateFormat, value: _selectedDateFormat);
            //save timeformat
            await Box.setString(
                key: Keys.selectedTimeFormat, value: _selectedTimeFormat);
            await Box.setBool(key: Keys.didDateFormatSelected, value: true);

            NavController.toHome();
          },
          progressValue: 3 / 9,
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
                        data: UiData.dateFormats,
                        value: _selectedDateFormat,
                        onChanged: (v) {
                          Buzz.feedback();
                          ;
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
                        data: UiData.timeFormats,
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
  }
}
