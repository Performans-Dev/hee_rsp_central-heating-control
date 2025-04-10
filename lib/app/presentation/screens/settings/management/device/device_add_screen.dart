import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/presentation/widgets/common/fab.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagementDeviceAddScreen extends StatefulWidget {
  const ManagementDeviceAddScreen({super.key});

  @override
  State<ManagementDeviceAddScreen> createState() =>
      _ManagementDeviceAddScreenState();
}

class _ManagementDeviceAddScreenState extends State<ManagementDeviceAddScreen> {
  late PageController _pageController;
  late final List<Widget> _pages;
  int currentPage = 0;
  late Device device;

  @override
  void initState() {
    super.initState();
    device = Device.empty();
    _pages = [
      buildPage1(),
      buildPage2(),
      buildPage3(),
      buildPage4(),
    ];
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          currentPage = _pageController.page!.toInt();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: 'Add Device'.tr,
        hasBackAction: true,
        selectedMenuIndex: 1,
        floatingActionButton: Row(
          spacing: 16,
          children: [
            SizedBox(width: 96),
            FabWidget(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              label: 'Previous'.tr,
              icon: Icons.arrow_back,
              heroTag: 'add_device_previous',
              enabled: currentPage > 0,
              color: ColorType.secondary,
            ),
            FabWidget(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              label: 'Next'.tr,
              icon: Icons.arrow_forward,
              heroTag: 'add_device_next',
              enabled: currentPage < _pages.length - 1,
              color: ColorType.secondary,
              trailingIcon: true,
            ),
            const Spacer(),
            FabWidget(
              onPressed: () {},
              label: 'Save'.tr,
              icon: Icons.save,
              heroTag: 'save_device',
              enabled: true,
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          children: _pages,
        ),
      );
    });
  }

  Widget buildPage1() {
    return const Text(
        'page 1\nTextfield: name\nIconPicker: icon\nDropdown: zone/group');
  }

  Widget buildPage2() {
    return const Text(
        'page 2\nDropdown: levelCount\nDropdown: outputCount\nDropdown: inputCount');
  }

  Widget buildPage3() {
    return const Text('page 3\nlevel-output-input -> state matrix');
  }

  Widget buildPage4() {
    return const Text('page 4: Show summary');
  }
}
