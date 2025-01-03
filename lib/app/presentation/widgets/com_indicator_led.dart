import 'dart:async';
import 'dart:math';

import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComIndicatorLedWidget extends StatelessWidget {
  const ComIndicatorLedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChannelController>(builder: (cc) {
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Text('Out', style: TextStyle(fontSize: 10)),
                PinIndicator(value: cc.pinSerState),
                PinIndicator(value: cc.pinSrclkState),
                PinIndicator(value: cc.pinRclkState),
                PinIndicator(value: cc.pinTxEnableState),
              ],
            ),
            Row(
              children: [
                const Text('Serial', style: const TextStyle(fontSize: 10)),
                PinIndicator(value: cc.pinUartModeTxState),
                PinIndicator(value: cc.pinBuzzerState),
                PinIndicator(value: cc.fanPinState),
                PinIndicator(value: cc.processingSerialLoop),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class PinIndicator extends StatelessWidget {
  const PinIndicator({
    super.key,
    this.value = false,
  });
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: value ? Colors.grey : Colors.orange,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class TxRxIndicator extends StatefulWidget {
  const TxRxIndicator({super.key});

  @override
  State<TxRxIndicator> createState() => _TxRxIndicatorState();
}

class _TxRxIndicatorState extends State<TxRxIndicator> {
  final Random _random = Random();
  bool _myBool = false;
  Timer? _timer;
  final int min = 10;
  final int max = 1000;

  @override
  void initState() {
    super.initState();
    _scheduleNextToggle();
  }

  void _toggleBool() {
    setState(() {
      _myBool = !_myBool;
    });
    _scheduleNextToggle();
  }

  void _scheduleNextToggle() {
    final interval = _random.nextInt(max - min + 1) + min;
    _timer = Timer(Duration(milliseconds: interval), _toggleBool);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: _myBool ? Colors.grey : Colors.orange,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
