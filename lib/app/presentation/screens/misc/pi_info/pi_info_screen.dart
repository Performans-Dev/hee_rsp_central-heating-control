import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PiInfoScreen extends StatelessWidget {
  const PiInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const b87 = Colors.black87;
    const style = TextStyle(color: b87);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        automaticallyImplyLeading: false,
        actionsIconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Device Information',
          style: style,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: GetBuilder<AppController>(
        builder: (app) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 20,
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
                        const InfoLabelValueWidget(
                          label: 'Product',
                          value: 'Heethings CC',
                          action: IconButton(
                              onPressed: null,
                              icon: Icon(Icons.developer_board)),
                          titleLevel: 2,
                        ),
                        InfoLabelValueWidget(
                          label: 'S/N',
                          value: '${app.deviceInfo?.serialNumber}',
                        ),
                        Center(
                          child: QrImageView(
                            data: app.deviceInfo?.serialNumber ?? 'N/A',
                            version: QrVersions.auto,
                            size: 100.0,
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
                        ),
                        const Divider(),
                        InfoLabelValueWidget(
                          label: 'Software',
                          value: '${app.deviceInfo?.appName}',
                        ),
                        InfoLabelValueWidget(
                          label: 'Version',
                          value: '${app.deviceInfo?.appVersion}',
                        ),
                        InfoLabelValueWidget(
                          label: 'Build',
                          value: '${app.deviceInfo?.appBuild}',
                        ),
                        InfoLabelValueWidget(
                          label: 'ID',
                          value: '${app.deviceInfo?.installationId}',
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 12,
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
                        const InfoLabelValueWidget(
                          label: 'Installed Hardware',
                          action: IconButton(
                            onPressed: null,
                            icon: Icon(Icons.refresh),
                          ),
                          titleLevel: 2,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) => Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const InfoLabelValueWidget(
                                    label: 'Model',
                                    value: 'HT2041.01',
                                  ),
                                  InfoLabelValueWidget(
                                    label: 'S/N',
                                    value: '2041.01.100.25$index',
                                  ),
                                  QrImageView(
                                    data: '2041.01.100.25$index',
                                    size: 100,
                                  ),
                                  const Divider(),
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
                  flex: 16,
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
                        InfoLabelValueWidget(
                          label: 'Connectivity',
                          action: IconButton(
                            onPressed: app.getNetworkInfo,
                            icon: const Icon(Icons.refresh),
                          ),
                          titleLevel: 2,
                        ),
                        InfoLabelValueWidget(
                          label: 'Status',
                          value:
                              app.didConnected ? 'Connected' : 'Disconnected',
                        ),
                        InfoLabelValueWidget(
                          label: 'IP Address',
                          value: app.networkIp,
                        ),
                        InfoLabelValueWidget(
                          label: 'Gateway',
                          value: app.networkGateway,
                        ),
                        InfoLabelValueWidget(
                          label: 'Network Name',
                          value: app.networkName,
                        ),
                        const Divider(),
                        const InfoLabelValueWidget(
                          label: 'Mac Addresses',
                          titleLevel: 2,
                        ),
                        const SizedBox(height: 12),
                        InfoLabelValueWidget(label: 'eth0', value: app.eth0Mac),
                        InfoLabelValueWidget(
                            label: 'wifi', value: app.wlan0Mac),
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

class InfoLabelValueWidget extends StatelessWidget {
  const InfoLabelValueWidget({
    super.key,
    required this.label,
    this.value,
    this.action,
    this.titleLevel = 3,
  });
  final String label;
  final String? value;
  final Widget? action;
  final int titleLevel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontSize: titleLevel == 1 ? 18 : null,
              fontWeight: titleLevel == 3 ? null : FontWeight.bold,
            ),
          ),
          if (value != null)
            Text(
              value!,
              style: const TextStyle(color: Colors.black87),
            ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
