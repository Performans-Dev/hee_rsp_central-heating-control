import 'dart:async';
import 'dart:io';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WallpaperWidget extends StatefulWidget {
  const WallpaperWidget({super.key});

  @override
  State<WallpaperWidget> createState() => _WallpaperWidgetState();
}

class _WallpaperWidgetState extends State<WallpaperWidget> {
  List<File> images = [];
  double opacity = 0.4;
  int index = 0;
  Duration duration = const Duration(milliseconds: 200);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        images.isEmpty
            ? Container()
            : AnimatedOpacity(
                duration: duration,
                opacity: opacity,
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  child: Image.file(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            color: Colors.black.withValues(alpha: 0.4),
            child: GetBuilder<DataController>(builder: (dc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 8,
                children: [
                  ...dc.zoneList.where((e) => e.hasThermostat).map((e) => Chip(
                        label: Text(
                            '${e.name}: ${dc.sensorListWithValues(e.id).first.value?.toStringAsPrecision(1)}°C'),
                      ))
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Future<void> _loadImages() async {
    final screenSaverType = ScreenSaverType
        .values[Box.getInt(key: Keys.screenSaverType, defaultVal: 2)];
    final directory = screenSaverType == ScreenSaverType.slidePictures
        ? Directory('/home/pi/Pictures')
        : screenSaverType == ScreenSaverType.fun
            ? Directory('/home/pi/Pictures/fun')
            : Directory('/home/pi/Pictures/static');

    if (directory.existsSync()) {
      final imageFiles = directory.listSync().where((file) =>
          file.path.endsWith('.jpg') ||
          file.path.endsWith('.jpeg') ||
          file.path.endsWith('.gif') ||
          file.path.endsWith('.png'));
      images = imageFiles.map((file) => File(file.path)).toList();
      startSlideShow();
    }
  }

  void startSlideShow() {
    final AppController appController = Get.find();
    timer = Timer.periodic(
        Duration(seconds: appController.preferencesDefinition.slideShowTimer),
        (t) {
      if (!mounted) {
        timer?.cancel();
        return;
      }
      setState(() {
        opacity = 0;
      });
      Future.delayed(duration, () {
        if (!mounted) return;
        setState(() {
          index = index >= images.length - 1 ? 0 : index + 1;
          opacity = 0.4;
        });
      });
    });
  }
}
