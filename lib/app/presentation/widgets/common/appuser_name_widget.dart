import 'package:flutter/material.dart';

class AppUserNameWidget extends StatelessWidget {
  const AppUserNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Developer', //TODO: acquire this from controller
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12),
    );
  }
}
