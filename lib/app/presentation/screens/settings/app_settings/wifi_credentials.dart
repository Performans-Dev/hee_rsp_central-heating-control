import 'package:central_heating_control/app/data/models/wifi.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WifiCredentialsScreen extends StatefulWidget {
  const WifiCredentialsScreen({super.key});

  @override
  State<WifiCredentialsScreen> createState() => _WifiCredentialsScreenState();
}

class _WifiCredentialsScreenState extends State<WifiCredentialsScreen> {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    final String? wifiJson = box.read('wifiCredentials');
    if (wifiJson != null) {
      final WiFiCredentials credentials = WiFiCredentials.fromJson(wifiJson);
      ssidController.text = credentials.ssid;
      passwordController.text = credentials.password;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 3,
      body: PiScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInputWidget(
              // SSID
              labelText: 'SSID',
              controller: ssidController,
              keyboardType: TextInputType.name,
            ),
            TextInputWidget(
              // Password
              labelText: 'Password',
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveCredentials,
              child: const Text('Save'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _deleteCredentials,
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCredentials() {
    String ssid = ssidController.text;
    String password = passwordController.text;

    if (ssid.isNotEmpty && password.isNotEmpty) {
      final credentials = WiFiCredentials(ssid: ssid, password: password);
      box.write('wifiCredentials', credentials.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credentials saved!')),
      );
      Get.back();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
    }
  }

  void _deleteCredentials() {
    box.remove('wifiCredentials');
    ssidController.clear();
    passwordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Credentials deleted!')),
    );
  }
}
