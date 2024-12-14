enum ConnectionState {
  none,
  connected,
}

enum NetworkIndicator {
  none,
  ethernet,
  wifi,
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
  none,
}

enum GpioGroup {
  inPin,
  outPin,
  buttonPin,
  uart,
  spi,
  buzzer,
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
  gpioNone,
}

enum HeaterDeviceConnectionType {
  none,
  ethernet,
  relay,
}

enum HeaterDeviceType {
  none,
  electric,
  electricThreePhase,
  liquidNaturalGas,
  liquidPetrolGas,
}

enum HeaterDeviceLevel {
  none,
  onOff,
  twoLevels,
  threeLevels,
}

enum HeaterState {
  off,
  auto,
  level1,
  level2,
  level3,
}

enum ErrorChannelType {
  nC,
  nO,
}

enum BuzzerType {
  none,
  mini,
  feedback,
  success,
  error,
  alarm,
  lock,
}

enum SubscriptionType {
  none,
  free,
  pro,
}

enum SetupConnectionState {
  none,
  checkingEth,
  checkingWifi,
  wifiForm,
  connected,
  notConnected,
}

enum AppUserLevel {
  user(0),
  admin(1),
  techSupport(2),
  manufacturer(3),
  developer(4);

  final int value;
  const AppUserLevel(this.value);
}

enum WebViewScreenState {
  idle,
  loading,
  loaded,
  error,
}

enum ScreenSaverType {
  blank,
  staticPicture,
  slidePictures,
}

enum SerialCommand {
  test(0x64),
  restartDevice(0x65),
  setMultiOut(0x66),
  readInputs(0x67),
  setSingleOut(0x68),
  readOutputs(0x69),
  readNtc(0x70);

  final int value;
  const SerialCommand(this.value);
}
