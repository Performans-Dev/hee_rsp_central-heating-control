import 'dart:async';
import 'dart:io';

import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';

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
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return images.isEmpty
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
          );
  }

  Future<void> _loadImages() async {
    final directory = isPi
        ? Directory('/home/pi/Pictures')
        : Directory('/home/ozge/Desktop/pi_wallpaper');

    if (directory.existsSync()) {
      final imageFiles = directory.listSync().where((file) =>
          file.path.endsWith('.jpg') ||
          file.path.endsWith('.jpeg') ||
          file.path.endsWith('.png'));
      images = imageFiles.map((file) => File(file.path)).toList();
      startSlideShow();
    }
  }

  void startSlideShow() {
    timer = Timer.periodic(const Duration(seconds: 11), (t) {
      setState(() {
        opacity = 0;
      });
      Future.delayed(duration, () {
        setState(() {
          index = index == images.length ? 0 : index + 1;
          opacity = 0.4;
        });
      });
    });
  }
}
