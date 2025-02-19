import 'package:flutter/material.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
    /* return GetBuilder<GpioController>(builder: (gc) {
      return AppScaffold(
        title: 'Diagnostics',
        selectedIndex: 3,
        body: PiScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        gc.openRelays(true);
                      },
                      child: const Text('Open Output')),
                  ElevatedButton(
                      onPressed: () {
                        gc.openRelays(false);
                      },
                      child: const Text('Close Output')),
                  const Text('oe:'),
                  Icon(
                    Icons.sunny,
                    color: gc.oeState ? Colors.red : Colors.grey.withValues(alpha: 0.3),
                  ),
                  const Text('ser:'),
                  Icon(
                    Icons.sunny,
                    color: gc.serState ? Colors.red : Colors.grey.withValues(alpha: 0.3),
                  ),
                  const Text('srclk:'),
                  Icon(
                    Icons.sunny,
                    color: gc.srclkState ? Colors.red : Colors.grey.withValues(alpha: 0.3),
                  ),
                  const Text('rclk:'),
                  Icon(
                    Icons.sunny,
                    color: gc.rclkState ? Colors.red : Colors.grey.withValues(alpha: 0.3),
                  ),
                ],
              ),
              Text(gc.log),
              // FormItemComponent(
              //   label: 'OUT PINS',
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       for (int i = 0; i < gc.outStates.length; i++)
              //         Card(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: UiDimens.formRadius,
              //           ),
              //           child: InkWell(
              //             onTap: () => gc.onOutTap(i),
              //             borderRadius: UiDimens.formRadius,
              //             child: ClipRRect(
              //               borderRadius: UiDimens.formRadius,
              //               child: Container(
              //                 padding: const EdgeInsets.all(10),
              //                 child: Column(
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //                     Text('${UiData.outPins[i]}'),
              //                     Icon(
              //                       Icons.sunny,
              //                       color: gc.outStates[i]
              //                           ? Colors.red
              //                           : Colors.grey.withValues(alpha: 0.3),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         )
              //     ],
              //   ),
              // ),
              const Divider(),
              FormItemComponent(
                label: 'IN PINS',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < gc.inStates.length; i++)
                      Card(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${UiData.inPins[i]}'),
                              Icon(
                                Icons.sunny,
                                color: !gc.inStates[i]
                                    ? Colors.green
                                    : Colors.grey.withValues(alpha: 0.3),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(),
              FormItemComponent(
                label: 'BUTTONS',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < gc.btnStates.length; i++)
                      Card(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${UiData.btnPins[i]}'),
                              Icon(
                                Icons.sunny,
                                color: !gc.btnStates[i]
                                    ? Colors.green
                                    : Colors.grey.withValues(alpha: 0.3),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(),
              FormItemComponent(
                label: 'Buzzer',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (final item in BuzzerType.values)
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: UiDimens.formRadius,
                        ),
                        child: InkWell(
                          onTap: () => gc.buzz(item),
                          borderRadius: UiDimens.formRadius,
                          child: ClipRRect(
                            borderRadius: UiDimens.formRadius,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(item.name.camelCaseToHumanReadable()),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(),
              const FormItemComponent(
                label: 'Serial',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ElevatedButton(
                        //   onPressed: () async => await gc.serialSend(),
                        //   child: const Text('Serial Send'),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () async => await gc.serialReceive(),
                        //   child: const Text('Serial Receive'),
                        // ),
                      ],
                    ),
                    // Text(gc.serialLog),
                  ],
                ),
              ),
              const Divider(),
              FormItemComponent(
                label: 'SPI',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async => await gc.readSpiSensor(),
                      child: const Text('Read Data'),
                    ),
                    Text(gc.spiLog),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }); */
  }
}
