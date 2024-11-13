import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PiInfoScreen extends StatelessWidget {
  const PiInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actionsIconTheme: const IconThemeData(color: Colors.black87),
        title: const Text('Pi Info'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: GetBuilder<AppController>(
        builder: (app) {
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    color: Colors.white,
                    height: double.infinity,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Serial Number',
                          style: TextStyle(color: Colors.black),
                        ),
                        QrImageView(
                          data: app.deviceInfo?.serialNumber ?? 'N/A',
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(
                            color: Colors.black87,
                            eyeShape: QrEyeShape.square,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            color: Colors.black87,
                            dataModuleShape: QrDataModuleShape.square,
                          ),
                        ),
                        Text(
                          app.deviceInfo?.serialNumber ?? 'N/A',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: double.infinity,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(4),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Connectivity',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text('eth0:'),
                        Text('wifi:'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
