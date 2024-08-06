import 'package:flutter/material.dart';

class CheckConnectionScreen extends StatelessWidget {
  const CheckConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Hangi yöntem ile bağlanmak istiyorsunuz?",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          
        ],
      ),
    );
  }
}
