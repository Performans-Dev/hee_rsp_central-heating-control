import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PiInfoScreen extends StatelessWidget {
  const PiInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            child: GetBuilder<AppController>(builder: (app) {
              return Material(
                child: Center(
                  child: Container(
                    color: Colors.white,
                    width: 400,
                    height: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'test',
                              style: TextStyle(color: Colors.black87),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.black87,
                              ),
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                        Divider(),
                        QrImageView(
                          data: app.deviceInfo?.serialNumber ?? 'N/A',
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                          eyeStyle: QrEyeStyle(color: Colors.black87),
                          dataModuleStyle:
                              QrDataModuleStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
