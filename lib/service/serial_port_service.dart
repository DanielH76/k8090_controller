import 'dart:typed_data';

import 'package:k8090_controller/consts/consts.dart';
import 'package:serial_port_win32/serial_port_win32.dart';

class RelayService {
  late final SerialPort port;

  RelayService(String portName) {
    port = SerialPort(portName);
    port.openWithSettings(
      BaudRate: RelayServiceConfigs.baudRate,
      Parity: RelayServiceConfigs.parity,
      StopBits: RelayServiceConfigs.stopBits,
      ByteSize: RelayServiceConfigs.byteSize,
    );
  }

  Future<void> sendONCommand(int relay) async {
    final bytes = Uint8List(7);

    bytes[0] = DelimiterBytes.start;
    bytes[1] = CommandBytes.on;
    bytes[2] = relay;
    bytes[3] = DataBytes.empty;
    bytes[4] = DataBytes.empty;
    bytes[5] = calculateChecksum(bytes);
    bytes[6] = DelimiterBytes.end;

    await port.writeBytesFromUint8List(bytes);
  }

  Future<void> sendOFFCommand(int relay) async {
    final bytes = Uint8List(7);

    bytes[0] = DelimiterBytes.start;
    bytes[1] = CommandBytes.off;
    bytes[2] = relay;
    bytes[3] = DataBytes.empty;
    bytes[4] = DataBytes.empty;
    bytes[5] = calculateChecksum(bytes);
    bytes[6] = DelimiterBytes.end;

    await port.writeBytesFromUint8List(bytes);
  }

  Future<void> sendTimerCommand(int relay, int seconds) async {
    final (highByteParamater, lowByteParameter) = getTimerParameters(seconds);

    final bytes = Uint8List(7);

    bytes[0] = DelimiterBytes.start;
    bytes[1] = CommandBytes.timer;
    bytes[2] = relay;
    bytes[3] = highByteParamater;
    bytes[4] = lowByteParameter;
    bytes[5] = calculateChecksum(bytes);
    bytes[6] = DelimiterBytes.end;

    await port.writeBytesFromUint8List(bytes);
  }

  Future<void> sendToggleRelayCommand(int relay) async {
    final bytes = Uint8List(7);

    bytes[0] = DelimiterBytes.start;
    bytes[1] = CommandBytes.toggle;
    bytes[2] = relay;
    bytes[3] = DataBytes.empty;
    bytes[4] = DataBytes.empty;
    bytes[5] = calculateChecksum(bytes);
    bytes[6] = DelimiterBytes.end;

    await port.writeBytesFromUint8List(bytes);
  }

  int calculateChecksum(Uint8List bytes) {
    return -(bytes[0] + bytes[1] + bytes[2] + bytes[3] + bytes[4]);
  }

  (int hightByte, int lowByte) getTimerParameters(int seconds) {
    int highByte = (seconds >> 8) & 0xFF;
    int lowByte = seconds & 0xFF;

    return (highByte, lowByte);
  }

  void dispose() {
    port.close();
  }
}
