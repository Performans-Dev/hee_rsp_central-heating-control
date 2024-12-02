import 'dart:async';
import 'dart:typed_data';

import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/models/serial.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:central_heating_control/app/data/services/message_handler.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';

class CommController extends GetxController {
  @override
  void onReady() {
    setSerialPort();
    setTxPin();
    serialMessageStreamController = StreamController<SerialMessage>.broadcast();
    super.onReady();
  }

  @override
  void onClose() {
    serialMessageStreamController.close();
    super.onClose();
  }

  // get serial port that has been initialized in gpio controller
  final Rxn<SerialPort> _serialPort = Rxn();
  SerialPort? get serialPort => _serialPort.value;
  void setSerialPort() {
    /*  final GpioController gpio = Get.find();
    _serialPort.value = gpio.serialPort;
    update();
    //
    registerStreamListener(); */
  }

  // get gpio pin that is responsible for sending / receiving messages
  //#region TX PIN
  final Rxn<GPIO> _txPin = Rxn();
  GPIO? get txPin => _txPin.value;

  void setTxPin() {
    /*   final GpioController gpio = Get.find();
    _txPin.value = gpio.outGpios.firstWhere((e) => e.line == 4);
    update();
    //
    txClose(); */
  }

  Future<void> txOpen() async {
    if (txPin == null) return;
    txPin!.write(true);
    await Future.delayed(const Duration(milliseconds: 10));
  }

  Future<void> txClose() async {
    if (txPin == null) return;
    txPin!.write(false);
    await Future.delayed(const Duration(milliseconds: 10));
  }
  //#endregion

  // get serial port settings from database
  // apply port settings.
  Future<void> getPortSettings() async {
    ///    baudrate: 9600,
    ///    bits: 8,
    ///    stopBits: 1,
    ///    parity: 0,
    ///    xonXoff: 0,
    ///    rts: 1,
    ///    cts: 0,
    ///    dsr: 0,
    ///    dtr: 1,

    if (serialPort == null) return;

    final SerialPortConfig config = SerialPortConfig();
    config.baudRate = 9600;
    config.bits = 8;
    config.parity = 0;
    config.stopBits = 1;
    config.xonXoff = 0;
    config.rts = 1;
    config.cts = 0;
    config.dsr = 0;
    config.dtr = 1;
    serialPort!.config = config;
  }

  // register serial port listener
  // create stream controller for receiving
  SerialMessageHandler handler = SerialMessageHandler();
  late StreamController<SerialMessage> serialMessageStreamController;
  void registerStreamListener() {
    handler.onMessage.listen((message) {
      List<int> data = CommonUtils.intListToUint8List(message);
      int crcInt = CommonUtils.serialUartCrc16(CommonUtils.intListToUint8List([
        data[1],
        data[2],
        data[3],
        data[4],
      ]));
      List<int> crcBytes = CommonUtils.getCrcBytes(crcInt);
      if (data[5] == crcBytes[0] && data[6] == crcBytes[1]) {
        onSerialMessageReceived(CommonUtils.uint8ListToIntList(message));
      }
    });
  }

  void onSerialMessageReceived(List<int> message) {
    SerialMessage m = SerialMessage(
      deviceId: message[1],
      command: message[2],
      data1: message[3],
      data2: message[4],
    );
    serialMessageStreamController.add(m);
  }

  // create sendMessage method
  Future<void> sendMessage(List<int> message) async {
    await txOpen();
    final result = serialPort!.write(Uint8List.fromList(message));
    await Future.delayed(const Duration(milliseconds: 10));
    LogService.addLog(LogDefinition(
      message: 'serial write: $result',
      type: LogType.sendSerialEvent,
    ));
    await txClose();
  }
}
