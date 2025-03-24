import 'dart:io';

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevLockScreenWidget extends StatefulWidget {
  const DevLockScreenWidget({super.key});

  @override
  State<DevLockScreenWidget> createState() => _DevLockScreenWidgetState();
}

class _DevLockScreenWidgetState extends State<DevLockScreenWidget> {
  List<File> images = [];

  @override
  void initState() {
    super.initState();

    _loadImages();
  }

  void _loadImages() async {
    final Directory directory = isPi
        ? Directory('/home/pi/Pictures')
        : Directory('/Users/io/Pictures/cc');
    if (directory.existsSync()) {
      final imageFiles = directory.listSync().where((file) =>
          file.path.endsWith('jpg') ||
          file.path.endsWith('jpeg') ||
          file.path.endsWith('png') ||
          file.path.endsWith('gif'));
      setState(() {
        images = imageFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child:  Text('Lock Screen'.tr),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text('Lock Screen Timer'.tr),
                  const Spacer(),
                  Text('${app.preferences.lockDurationIdleTimeout} s'),
                  SizedBox(
                    width: 300,
                    child: Slider(
                      value: app.preferences.lockDurationIdleTimeout.toDouble(),
                      onChanged: (value) {
                        app.setPreferences(app.preferences
                            .copyWith(lockDurationIdleTimeout: value.toInt()));
                      },
                      min: 15.0,
                      max: 300.0,
                      divisions: 57,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text('Screen Saver Type'.tr),
                  const Spacer(),
                  ToggleButtons(
                    isSelected: ScreenSaverType.values
                        .map((e) => app.preferences.screenSaverType == e)
                        .toList(),
                    onPressed: (index) {
                      app.setPreferences(app.preferences.copyWith(
                          screenSaverType: ScreenSaverType.values[index]));
                    },
                    constraints:
                        const BoxConstraints(minWidth: 100, minHeight: 40),
                    borderRadius: UiDimens.br12,
                    children: ScreenSaverType.values
                        .map((e) => Text(e.name.tr))
                        .toList(),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: app.preferences.screenSaverType ==
                      ScreenSaverType.staticPicture
                  ? images.isEmpty
                      ? Text('No images in folder'.tr)
                      : SizedBox(
                          width: double.infinity,
                          height: 80,
                          child: ListView.builder(
                            itemBuilder: (context, index) => Container(
                              width: 80,
                              height: 80,
                              margin: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () {
                                  app.setPreferences(app.preferences
                                      .copyWith(selectedImageIndex: index));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 4,
                                      color: app.preferences
                                                  .selectedImageIndex ==
                                              index
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .surface,
                                    ),
                                  ),
                                  child: Image.file(images[index],
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            itemCount: images.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        )
                  : Row(
                      children: [
                        Text('Slide Duration'.tr),
                        const Spacer(),
                        Text('${app.preferences.slideShowDuration} s'),
                        SizedBox(
                          width: 300,
                          child: Slider(
                            value: app.preferences.slideShowDuration.toDouble(),
                            onChanged: (value) {
                              app.setPreferences(app.preferences
                                  .copyWith(slideShowDuration: value.toInt()));
                            },
                            min: 1.0,
                            max: 30.0,
                            divisions: 29,
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      );
    });
  }
}
