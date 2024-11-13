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
                    color: Colors.white.withOpacity(0.9),
                    margin: EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                    padding: EdgeInsets.all(20),
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
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                color: Colors.white,
                                height: double.infinity,
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.all(4),
                                margin: EdgeInsets.all(4),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Serial Number',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    QrImageView(
                                      data:
                                          app.deviceInfo?.serialNumber ?? 'N/A',
                                      version: QrVersions.auto,
                                      size: 200.0,
                                      backgroundColor: Colors.white,
                                      eyeStyle: QrEyeStyle(
                                        color: Colors.black87,
                                        eyeShape: QrEyeShape.square,
                                      ),
                                      dataModuleStyle: QrDataModuleStyle(
                                        color: Colors.black87,
                                        dataModuleShape:
                                            QrDataModuleShape.square,
                                      ),
                                    ),
                                    Text(
                                      app.deviceInfo?.serialNumber ?? 'N/A',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                height: double.infinity,
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.all(4),
                                margin: EdgeInsets.all(4),
                                child: Column(
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
