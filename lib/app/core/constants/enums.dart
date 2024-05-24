enum ConnectionState {
  none,
  connected,
}

enum JobState {
  idle,
  requested,
  success,
  error,
}

enum SnackbarType {
  info,
  success,
  warning,
  error,
}

enum GpioDirection {
  pinIn,
  pinOut,
  other,
}

enum GpioGroup {
  inPin,
  outPin,
  buttonPin,
  uart,
  spi,
  empty,
}

enum GpioPin {
  gpio0,
  gpio1,
  gpio2,
  gpio3,
  gpio4,
  gpio5,
  gpio6,
  gpio7,
  gpio8,
  gpio9,
  gpio10,
  gpio11,
  gpio12,
  gpio13,
  gpio14,
  gpio15,
  gpio16,
  gpio17,
  gpio18,
  gpio19,
  gpio20,
  gpio21,
  gpio22,
  gpio23,
  gpio24,
  gpio25,
  gpio26,
  gpio27,
}

enum HeaterDeviceConnectionType {
  ethernet,
  relay,
}

enum HeaterDeviceType {
  electric,
  naturalGas,
}

enum ErrorChannelType {
  na,
  no,
}


