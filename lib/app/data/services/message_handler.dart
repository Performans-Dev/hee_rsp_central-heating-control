import 'dart:async';

import 'package:flutter/foundation.dart';

class SerialMessageHandler {
  final List<int> _buffer = [];
  final StreamController<Uint8List> _controller =
      StreamController<Uint8List>.broadcast();

  // Expose the stream to allow others to subscribe to the messages
  Stream<Uint8List> get onMessage => _controller.stream;

  // Constants for message structure
  static const int startByte = 0x3A;
  static const int stopByte1 = 0x0D;
  static const int stopByte2 = 0x0A;
  static const int normalMessageLength = 9; // Standard message length
  static const int serialNumberCommand = 0xCA;
  static const int hardwareVersionCommand = 0xCB;
  static const int firmwareVersionCommand = 0xCC;
  static const int serialNumberMessageLength =
      21; // Length for serial number response
  static const int versionMessageLength = 28; // Length for version responses

  // Function to determine message length based on command
  int _getMessageLength(List<int> buffer) {
    if (buffer.length >= 3) {
      switch (buffer[2]) {
        case serialNumberCommand:
          return serialNumberMessageLength;
        case hardwareVersionCommand:
        case firmwareVersionCommand:
          return versionMessageLength;
        default:
          return normalMessageLength;
      }
    }
    return normalMessageLength;
  }

  // Function to handle incoming data from stream
  void onDataReceived(Uint8List data) {
    for (var byte in data) {
      _buffer.add(byte);

      // Get expected message length based on command
      int expectedLength = _getMessageLength(_buffer);

      // Check if the buffer has the required length for a full message
      if (_buffer.length >= expectedLength) {
        // Check for start byte and stop bytes
        if (_buffer[0] == startByte &&
            _buffer[expectedLength - 2] == stopByte1 &&
            _buffer[expectedLength - 1] == stopByte2) {
          // Extract the message
          Uint8List message =
              Uint8List.fromList(_buffer.sublist(0, expectedLength));

          // Add the message to the stream for subscribers
          _controller.add(message);

          // Clear buffer for next message
          _buffer.clear();
        } else {
          // Remove invalid or incomplete bytes and log the error

          _buffer.removeAt(0);
        }
      }
    }
  }

  // Close the StreamController when no longer needed
  void dispose() {
    _controller.close();
  }
}
