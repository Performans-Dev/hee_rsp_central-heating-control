import 'dart:io';

import 'package:central_heating_control/app/core/utils/device.dart';
import 'package:central_heating_control/app/data/models/chc_device.dart';
import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';

class InitialTestScreen extends StatefulWidget {
  const InitialTestScreen({super.key});

  @override
  State<InitialTestScreen> createState() => _InitialTestScreenState();
}

class _InitialTestScreenState extends State<InitialTestScreen> {
  late ChcDevice _deviceInfo;
  bool _isConnected = false;
  late String _provisionResult;

  @override
  void initState() {
    super.initState();
    _provisionResult = "";
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    ChcDevice device = await DeviceUtils.createDeviceInfo();
    setState(() {
      _deviceInfo = device;
    });
  }

  /// Wi-Fi ağına otomatik bağlan
  Future<void> _connectToWifi() async {
    const ssid = "HeethingsTech";
    const password = "12345678";
    // Shell komutu kullanarak Wi-Fi ağına bağlan
    final result = await Process.run(
        'nmcli', ['dev', 'wifi', 'connect', ssid, 'password', password]);

    setState(() {
      _isConnected = result.exitCode == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Production Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Device Serial Number: ${_deviceInfo.serialNumber}'),
            const SizedBox(height: 20),
            QrImageView(
              data: _deviceInfo.serialNumber,
              version: QrVersions.auto,
              size: 150.0,
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
            const SizedBox(height: 20),
            Text(
                'Connection Status: ${_isConnected ? "Connected" : "Disconnected"}'),
            ElevatedButton(
              onPressed: _connectToWifi,
              child: Text(_isConnected ? 'Disconnect' : 'Connect to Wi-Fi'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Trigger Provision'),
            ),
            const SizedBox(height: 20),
            Text('Provision Result: $_provisionResult'),
          ],
        ),
      ),
    );
  }
}
