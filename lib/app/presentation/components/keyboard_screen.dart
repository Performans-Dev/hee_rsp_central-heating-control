import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnScreenKeyboard extends StatelessWidget {
  const OnScreenKeyboard({super.key});
  //String labelText
  //String? initialValue
  //String? hintText
  //result<-

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/kb.png',
            fit: BoxFit.contain,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 800,
              height: 200,
              color: Colors.orange,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Get.back(),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => Get.back(result: 'icindeki yazi budur'),
            ),
          ),
        ],
      ),
    );
  }
}
