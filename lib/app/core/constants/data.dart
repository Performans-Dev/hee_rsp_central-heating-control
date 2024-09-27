import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/channel.dart';
import 'package:central_heating_control/app/data/models/com_port.dart';

class UiData {
  static final List<Channel> channels = [
    Channel(
        name: 'CHO-1',
        id: 'out1',
        direction: GpioDirection.pinOut,
        group: GpioGroup.outPin),
    Channel(
        name: 'CHO-2',
        id: 'out2',
        direction: GpioDirection.pinOut,
        group: GpioGroup.outPin),
    Channel(
        name: 'CHO-3',
        id: 'out3',
        direction: GpioDirection.pinOut,
        group: GpioGroup.outPin),
    Channel(
        name: 'CHO-4',
        id: 'out4',
        direction: GpioDirection.pinOut,
        group: GpioGroup.outPin),
    Channel(
        name: 'CHO-5',
        id: 'out5',
        direction: GpioDirection.pinOut,
        group: GpioGroup.outPin),
    Channel(
        name: 'CHO-6',
        id: 'out6',
        direction: GpioDirection.pinOut,
        group: GpioGroup.outPin),
    Channel(
        name: 'CHO-7',
        id: 'out7',
        direction: GpioDirection.pinOut,
        group: GpioGroup.outPin),
    Channel(
        name: 'CHO-8',
        id: 'out8',
        direction: GpioDirection.pinOut,
        group: GpioGroup.outPin),
    Channel(
        name: 'CHI-1',
        id: 'in1',
        direction: GpioDirection.pinIn,
        group: GpioGroup.inPin),
    Channel(
        name: 'CHI-2',
        id: 'in2',
        direction: GpioDirection.pinIn,
        group: GpioGroup.inPin),
    Channel(
        name: 'CHI-3',
        id: 'in3',
        direction: GpioDirection.pinIn,
        group: GpioGroup.inPin),
    Channel(
        name: 'CHI-4',
        id: 'in4',
        direction: GpioDirection.pinIn,
        group: GpioGroup.inPin),
    Channel(
        name: 'CHI-5',
        id: 'in5',
        direction: GpioDirection.pinIn,
        group: GpioGroup.inPin),
    Channel(
        name: 'CHI-6',
        id: 'in6',
        direction: GpioDirection.pinIn,
        group: GpioGroup.inPin),
    Channel(
        name: 'CHI-7',
        id: 'in7',
        direction: GpioDirection.pinIn,
        group: GpioGroup.inPin),
    Channel(
        name: 'CHI-8',
        id: 'in8',
        direction: GpioDirection.pinIn,
        group: GpioGroup.inPin),
    Channel(
        name: 'CHB-1',
        id: 'btn1',
        direction: GpioDirection.pinIn,
        group: GpioGroup.buttonPin),
    Channel(
        name: 'CHB-2',
        id: 'btn2',
        direction: GpioDirection.pinIn,
        group: GpioGroup.buttonPin),
    Channel(
        name: 'CHB-3',
        id: 'btn3',
        direction: GpioDirection.pinIn,
        group: GpioGroup.buttonPin),
    Channel(
        name: 'CHB-4',
        id: 'btn4',
        direction: GpioDirection.pinIn,
        group: GpioGroup.buttonPin),
  ];

  static final List<ComPort> ports = [
    ComPort(
      id: 'SER',
      title: 'Out-1',
      pinNumber: GpioPin.gpio23,
      direction: GpioDirection.pinOut,
      group: GpioGroup.outPin,
    ),
    ComPort(
      id: 'SRCLK',
      title: 'Out-2',
      pinNumber: GpioPin.gpio24,
      direction: GpioDirection.pinOut,
      group: GpioGroup.outPin,
    ),
    ComPort(
      id: 'RCLK',
      title: 'Out-3',
      pinNumber: GpioPin.gpio25,
      direction: GpioDirection.pinOut,
      group: GpioGroup.outPin,
    ),
    ComPort(
      id: 'OE',
      title: 'Out-4',
      pinNumber: GpioPin.gpio21,
      direction: GpioDirection.pinOut,
      group: GpioGroup.outPin,
    ),
    ComPort(
      id: 'MOSI',
      title: 'Out-5',
      pinNumber: GpioPin.gpio10,
      direction: GpioDirection.pinOut,
      group: GpioGroup.spi,
    ),
    ComPort(
      id: 'SCLK',
      title: 'Out-6',
      pinNumber: GpioPin.gpio11,
      direction: GpioDirection.pinOut,
      group: GpioGroup.spi,
    ),
    ComPort(
      id: 'CS',
      title: 'Out-7',
      pinNumber: GpioPin.gpio8,
      direction: GpioDirection.pinOut,
      group: GpioGroup.spi,
    ),
    ComPort(
      id: 'RE',
      title: 'Out-8',
      pinNumber: GpioPin.gpio4,
      direction: GpioDirection.pinOut,
      group: GpioGroup.uart,
    ),
    ComPort(
      id: 'BUZZER',
      title: 'Buzzer',
      pinNumber: GpioPin.gpio0,
      direction: GpioDirection.pinOut,
      group: GpioGroup.buzzer,
    ),
    ComPort(
      id: 'IN0',
      title: 'In-1',
      pinNumber: GpioPin.gpio5,
      direction: GpioDirection.pinIn,
      group: GpioGroup.inPin,
    ),
    ComPort(
      id: 'IN1',
      title: 'In-2',
      pinNumber: GpioPin.gpio6,
      direction: GpioDirection.pinIn,
      group: GpioGroup.inPin,
    ),
    ComPort(
      id: 'IN2',
      title: 'In-3',
      pinNumber: GpioPin.gpio12,
      direction: GpioDirection.pinIn,
      group: GpioGroup.inPin,
    ),
    ComPort(
      id: 'IN3',
      title: 'In-4',
      pinNumber: GpioPin.gpio13,
      direction: GpioDirection.pinIn,
      group: GpioGroup.inPin,
    ),
    ComPort(
      id: 'IN4',
      title: 'In-5',
      pinNumber: GpioPin.gpio19,
      direction: GpioDirection.pinIn,
      group: GpioGroup.inPin,
    ),
    ComPort(
      id: 'IN5',
      title: 'In-6',
      pinNumber: GpioPin.gpio16,
      direction: GpioDirection.pinIn,
      group: GpioGroup.inPin,
    ),
    ComPort(
      id: 'IN6',
      title: 'In-7',
      pinNumber: GpioPin.gpio26,
      direction: GpioDirection.pinIn,
      group: GpioGroup.inPin,
    ),
    ComPort(
      id: 'IN7',
      title: 'In-8',
      pinNumber: GpioPin.gpio20,
      direction: GpioDirection.pinIn,
      group: GpioGroup.inPin,
    ),
    ComPort(
      id: 'BTN0',
      title: 'Btn-1',
      pinNumber: GpioPin.gpio17,
      direction: GpioDirection.pinIn,
      group: GpioGroup.buttonPin,
    ),
    ComPort(
      id: 'BTN1',
      title: 'Btn-2',
      pinNumber: GpioPin.gpio18,
      direction: GpioDirection.pinIn,
      group: GpioGroup.buttonPin,
    ),
    ComPort(
      id: 'BTN2',
      title: 'Btn-3',
      pinNumber: GpioPin.gpio27,
      direction: GpioDirection.pinIn,
      group: GpioGroup.buttonPin,
    ),
    ComPort(
      id: 'BTN3',
      title: 'Btn-4',
      pinNumber: GpioPin.gpio22,
      direction: GpioDirection.pinIn,
      group: GpioGroup.buttonPin,
    ),
    ComPort(
      id: 'MISO',
      title: 'Btn-5',
      pinNumber: GpioPin.gpio9,
      direction: GpioDirection.pinIn,
      group: GpioGroup.spi,
    ),
  ];

  static List<ComPort> getPortsDropdown(GpioGroup? group) {
    return [
      ComPort.empty(),
      ...ports.where((element) =>
          group != null ? element.group == group : element.id.isNotEmpty)
    ];
  }

  static List<Channel> getChannelsDropdown(GpioGroup? group) {
    return [
      Channel.empty(),
      ...channels
          .where((e) => group != null ? e.group == group : e.id.isNotEmpty)
    ];
  }

  static List<String> colorList = [
    '',
    '#FF5733', // Orange
    '#33FF57', // Green
    '#3357FF', // Blue
    '#FF33A1', // Pink
    '#FFDB33', // Yellow
    '#33FFF5', // Cyan
    '#B833FF', // Purple
    '#A1FF33' // Lime
  ];

  static List<int> get outPins => ports
      .where((e) => e.group == GpioGroup.outPin)
      .map((e) => e.pinNumber.index)
      .toList();

  static List<int> get inPins => ports
      .where((e) => e.group == GpioGroup.inPin)
      .map((e) => e.pinNumber.index)
      .toList();

  static List<int> get btnPins => ports
      .where((e) => e.group == GpioGroup.buttonPin)
      .map((e) => e.pinNumber.index)
      .toList();
}
