import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateFoldersScreen extends StatefulWidget {
  const CreateFoldersScreen({super.key});

  @override
  State<CreateFoldersScreen> createState() => _CreateFoldersScreenState();
}

class _CreateFoldersScreenState extends State<CreateFoldersScreen> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  runInitTask() async {
    final AppController appController = Get.find();
    if (appController.didCheckFolders) {
      NavController.toHome();
    } else {
      setState(() => counter++);
      Future.delayed(const Duration(milliseconds: 100), () => runInitTask());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [Text('$counter%')],
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
