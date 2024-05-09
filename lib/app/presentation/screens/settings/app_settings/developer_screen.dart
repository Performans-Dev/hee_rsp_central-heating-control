// import 'package:dart_periphery/dart_periphery.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rpi_gpio/gpio.dart';
import 'package:rpi_gpio/rpi_gpio.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  final List<int> outPins = [
    17, //0
    27, //1
    22, //2
    6, //3
    26, //4
    25, //5
    23, //6
    24, //7
  ];
  final List<int> inPins = [
    4, //0
    10, //1
    9, //2
    11, //3
    13, //4
    19, //5
    18, //6
    8, //7
  ];
  final List<int> btnPins = [];

  late final RpiGpio gpio;

  // late GPIOconfig config;
  // late GPIO gpio;
  // List<GPIO> leds = [];
  // List<GPIO> triggers = [];
  // List<GPIO> buttons = [];
  List<GpioOutput> leds = [];
  List<GpioInput> triggers = [];
  List<StreamSubscription<bool>> triggerSubscriptions = [];

  late List<bool> ledStates;
  late List<bool> triggerStates;
  late List<bool> buttonStates;
  bool ready = false;
  List<String> errors = [];
  final Duration blink = Duration(milliseconds: 500);
  int debounce = 250;

  @override
  void initState() {
    super.initState();
    initGPIO();
    // initGPIO();
  }

  @override
  void dispose() {
    // gpio.dispose();
    // for (final element in leds) {
    //   element.dispose();
    // }
    for (final item in triggerSubscriptions) {
      item.cancel();
    }
    gpio.dispose();
    super.dispose();
  }

  Future<void> initGPIO() async {
    try {
      gpio = await initialize_RpiGpio();

      for (final item in outPins) {
        leds.add(gpio.output(item));
      }
      for (final item in inPins) {
        triggers.add(gpio.input(item, Pull.up));
      }
      for (int i = 0; i < triggers.length; i++) {
        triggerSubscriptions.add(triggers[i].values.listen((event) {
          triggered(i, event);
        }));
      }
    } on Exception catch (e) {
      print(e);
    }
    setState(() {
      ready = true;
    });
  }

  // initGPIO() async {
  //   config = GPIOconfig.defaultValues();
  //   config.direction = GPIOdirection.gpioDirOut;

  //   for (final item in inPins) {
  //     try {
  //       triggers.add(GPIO(item, GPIOdirection.gpioDirIn));
  //     } on Exception catch (e) {
  //       errors.add('TRIGGER: $item\n${e.toString()}');
  //     }
  //     await Future.delayed(Duration(milliseconds: 100));
  //   }
  //   for (final item in outPins) {
  //     try {
  //       leds.add(GPIO(item, GPIOdirection.gpioDirOut));
  //     } on Exception catch (e) {
  //       errors.add('LED: $item\n${e.toString()}');
  //     }
  //     await Future.delayed(Duration(milliseconds: 100));
  //   }

  //   for (final item in btnPins) {
  //     try {
  //       buttons.add(GPIO(item, GPIOdirection.gpioDirIn));
  //     } on Exception catch (e) {
  //       errors.add('BTN: $item\n${e.toString()}');
  //     }
  //     await Future.delayed(Duration(milliseconds: 100));
  //   }

  //   ledStates = leds.map((e) => false).toList();
  //   triggerStates = triggers.map((e) => true).toList();
  //   buttonStates = buttons.map((e) => true).toList();
  //   gpio = GPIO.advanced(5, config);
  //   setState(() {
  //     ready = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPIO'),
        actions: [
          // IconButton(
          //     onPressed: askButtonStates, icon: Icon(Icons.question_mark))
        ],
      ),
      body: !ready
          ? Center(
              child: Text('wait'),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int index = 0; index < leds.length; index++)
                            SizedBox(
                              height: 38,
                              child: ElevatedButton(
                                onPressed: () => toggleLed(index),
                                child: Text(
                                    '$index ${ledStates[index] ? ' True' : ' False'}'),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          for (int index = 0; index < triggers.length; index++)
                            SizedBox(
                              height: 38,
                              child:
                                  Text('Trg $index: ${triggerStates[index]}'),
                            )
                        ],
                      ),
                    ),
                    // Expanded(
                    //   flex: 1,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     mainAxisSize: MainAxisSize.max,
                    //     children: [
                    //       for (int index = 0; index < buttons.length; index++)
                    //         SizedBox(
                    //           height: 38,
                    //           child: Text('Btn $index: ${buttonStates[index]}'),
                    //         )
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        itemBuilder: (context, index) => Text(
                          errors[index],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        itemCount: errors.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void triggered(int index, bool value) {
    setState(() {
      triggerStates[index] = value;
    });
  }

  void toggleLed(int index) async {
    setState(() {
      ledStates[index] = !ledStates[index];
    });
    leds[index].value = ledStates[index];
    // leds[index].write(ledStates[index]);
  }

  // void askButtonStates() async {
  //   setState(() {
  //     for (int i = 0; i < triggers.length; i++) {
  //       triggerStates[i] = triggers[i].read();

  //       ledStates[i] = triggerStates[i];
  //       leds[i].write(ledStates[i]);
  //     }
  //   });
  // }
}
