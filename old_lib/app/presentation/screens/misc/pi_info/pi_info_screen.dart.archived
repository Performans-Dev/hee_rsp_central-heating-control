import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PiInfoScreen extends StatefulWidget {
  const PiInfoScreen({super.key});

  @override
  State<PiInfoScreen> createState() => _PiInfoScreenState();
}

class _PiInfoScreenState extends State<PiInfoScreen> {
  String? qrCodeData;

  @override
  Widget build(BuildContext context) {
    const b87 = Colors.black87;
    const style = TextStyle(color: b87);
    return Scaffold(
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
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
          return Stack(
            children: [
              Container(
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
                            infoLabelValueWidget(
                              label: 'Product',
                              value: 'Heethings CC',
                              action: const IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.developer_board)),
                              titleLevel: 2,
                            ),
                            infoLabelValueWidget(
                                label: 'S/N',
                                qr: '${app.deviceInfo?.serialNumber}'),
                            infoLabelValueWidget(
                              label: 'ID',
                              qr: '${app.deviceInfo?.installationId}',
                            ),
                            infoLabelValueWidget(
                              label: 'Model',
                              value: '${app.deviceInfo?.model}',
                            ),
                            infoLabelValueWidget(
                              label: 'Software',
                              value: '${app.deviceInfo?.appName}',
                            ),
                            infoLabelValueWidget(
                              label: 'Package',
                              value: '${app.deviceInfo?.packageName}',
                            ),
                            infoLabelValueWidget(
                              label: 'Version',
                              value: '${app.deviceInfo?.appVersion}',
                            ),
                            infoLabelValueWidget(
                              label: 'Build',
                              value: '${app.deviceInfo?.appBuild}',
                            ),
                            infoLabelValueWidget(
                              label: 'OS',
                              value: '${app.deviceInfo?.os}',
                            ),
                            infoLabelValueWidget(
                              label: 'OS Version',
                              value: '${app.deviceInfo?.osVersion}',
                            ),
                            infoLabelValueWidget(
                              label: 'OS SDK',
                              value: '${app.deviceInfo?.osVersionSdk}',
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            infoLabelValueWidget(
                              label: 'Connectivity',
                              action: IconButton(
                                onPressed: app.getNetworkInfo,
                                icon: const Icon(Icons.refresh),
                              ),
                              titleLevel: 2,
                            ),
                            infoLabelValueWidget(
                              label: 'Status',
                              value: app.didConnected
                                  ? 'Connected'
                                  : 'Disconnected',
                            ),
                            infoLabelValueWidget(
                              label: 'IP Address',
                              value: app.networkIp,
                            ),
                            infoLabelValueWidget(
                              label: 'Gateway',
                              value: app.networkGateway,
                            ),
                            infoLabelValueWidget(
                              label: 'Network Name',
                              value: app.networkName,
                            ),
                            const Divider(),
                            infoLabelValueWidget(
                              label: 'Mac Addresses',
                              titleLevel: 2,
                            ),
                            const SizedBox(height: 12),
                            infoLabelValueWidget(
                                label: 'eth0', qr: app.eth0Mac),
                            infoLabelValueWidget(
                                label: 'wifi', qr: app.wlan0Mac),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (qrCodeData != null && qrCodeData!.isNotEmpty)
                InkWell(
                  onTap: () => setState(() => qrCodeData = null),
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    color: Colors.black38,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: IgnorePointer(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                qrCodeData!,
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 20),
                              ),
                              QrImageView(
                                data: qrCodeData!,
                                size: 300,
                                version: QrVersions.auto,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget infoLabelValueWidget({
    required String label,
    String? value,
    Widget? action,
    int titleLevel = 3,
    String? qr,
  }) {
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
          qr != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      qr,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code),
                      onPressed: () => setState(() => qrCodeData = qr),
                    ),
                  ],
                )
              : action ??
                  (value != null
                      ? Text(
                          value,
                          style: const TextStyle(color: Colors.black87),
                        )
                      : Container()),
        ],
      ),
    );
  }
}
