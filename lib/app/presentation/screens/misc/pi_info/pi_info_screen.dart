import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PiInfoScreen extends StatelessWidget {
  const PiInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            color: Colors.black38,
            constraints: BoxConstraints.expand(),
            child: Material(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text('test'),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
