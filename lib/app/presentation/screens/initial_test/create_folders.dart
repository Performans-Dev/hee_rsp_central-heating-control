import 'package:flutter/material.dart';

class CreateFoldersScreen extends StatefulWidget {
  const CreateFoldersScreen({super.key});

  @override
  State<CreateFoldersScreen> createState() => _CreateFoldersScreenState();
}

class _CreateFoldersScreenState extends State<CreateFoldersScreen> {
  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  runInitTask() {
    //TODO:TRİGger folder create function
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
