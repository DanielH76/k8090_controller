import 'dart:typed_data';

import 'package:serial_port_win32/serial_port_win32.dart';

class RelayService {
  late final SerialPort port;

  RelayService(String portName) {
    port = SerialPort(portName);
    port.openWithSettings(BaudRate: 19200, Parity: 0, StopBits: 1, ByteSize: 8);
  }

  Future<void> sendONCommand20(int relay) async {
    final bytes = Uint8List(5);
    bytes[0] = 0x04;
    bytes[1] = 0x20;
    bytes[2] = relay;
    bytes[3] = 0x00;
    bytes[4] = bytes[0] ^ bytes[1] ^ bytes[2] ^ bytes[3];
    await port.writeBytesFromUint8List(bytes);
  }

  Future<void> sendOFFCommand21(int relay) async {
    final bytes = Uint8List(5);
    bytes[0] = 0x04;
    bytes[1] = 0x21;
    bytes[2] = relay;
    bytes[3] = 0x00;
    bytes[4] = bytes[0] ^ bytes[1] ^ bytes[2] ^ bytes[3];
    port.writeBytesFromUint8List(bytes);
  }

  Future<void> sendTimerCommand22(int relay) async {
    final bytes = Uint8List(5);
    bytes[0] = 0x04;
    bytes[1] = 0x22;
    bytes[2] = relay;
    bytes[3] = 0x05;
    bytes[4] = bytes[0] ^ bytes[1] ^ bytes[2] ^ bytes[3];
    port.writeBytesFromUint8List(bytes);
  }

  Future<void> sendONCommand11(int relay) async {
    final bytes = Uint8List(5);
    bytes[0] = 0x04;
    bytes[1] = 0x11;
    bytes[2] = relay;
    bytes[3] = 0x00;
    bytes[4] = bytes[0] ^ bytes[1] ^ bytes[2] ^ bytes[3];
    port.writeBytesFromUint8List(bytes);
  }

  Future<void> sendOFFCommand12(int relay) async {
    final bytes = Uint8List(5);
    bytes[0] = 0x04;
    bytes[1] = 0x12;
    bytes[2] = relay;
    bytes[3] = 0x00;
    bytes[4] = bytes[0] ^ bytes[1] ^ bytes[2] ^ bytes[3];
    port.writeBytesFromUint8List(bytes);
  }

  Future<void> sendTimerCommand41(int relay) async {
    final bytes = Uint8List(5);
    bytes[0] = 0x04;
    bytes[1] = 0x41;
    bytes[2] = relay;
    bytes[3] = 0x05;
    bytes[4] = bytes[0] ^ bytes[1] ^ bytes[2] ^ bytes[3];
    port.writeBytesFromUint8List(bytes);
  }

  void dispose() {
    port.close();
  }
}
