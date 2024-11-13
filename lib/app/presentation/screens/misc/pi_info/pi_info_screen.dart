import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PiInfoScreen extends StatelessWidget {
  const PiInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final b87 = Colors.black87;
    final style = TextStyle(color: b87);
    final styleT = TextStyle(color: b87, fontWeight: FontWeight.bold);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        automaticallyImplyLeading: false,
        actionsIconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          'Pi Info',
          style: style,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
          SizedBox(width: 8)
        ],
      ),
      body: GetBuilder<AppController>(
        builder: (app) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    height: double.infinity,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Product', style: styleT),
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
                          'Serial Number:\n'
                          '${app.deviceInfo?.serialNumber}',
                          style: style,
                        ),
                        Divider(),
                        Text(
                          'Software Version:\n${app.deviceInfo?.appVersion}',
                          style: style,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    height: double.infinity,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Hardware', style: styleT),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) => Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Expansion #${index + 1}\n'
                                    '2041.01.100.25$index',
                                    textAlign: TextAlign.center,
                                    style: style,
                                  ),
                                  QrImageView(
                                    data: '2041.01.100.25$index',
                                    size: 100,
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                            itemCount: 8,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    height: double.infinity,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Connectivity', style: styleT),
                        Text(
                          'Status: ${app.didConnected ? 'Connected' : 'Disconnected'}',
                          style: style,
                        ),
                        Text(
                          'IP Address',
                          style: style,
                        ),
                        Text(
                          'Gateway',
                          style: style,
                        ),
                        Text(
                          'Network Name',
                          style: style,
                        ),
                        Text('eth0:\nMac address:', style: style),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
