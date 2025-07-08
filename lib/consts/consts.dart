// all byte values taken
// from protocol manual

class CommandBytes {
  static int get on => 0x11;
  static int get off => 0x12;
  static int get toggle => 0x14;
  static int get timer => 0x41;
}

class DelimiterBytes {
  static int get start => 0x04;
  static int get end => 0x0f;
}

class RelayServiceConfigs {
  static int get baudRate => 19200;
  static int get parity => 0;
  static int get stopBits => 1;
  static int get byteSize => 8;
}

class DataBytes {
  static int get empty => 0x00;
}

class Relays {
  static int get one => 0x01;
  static int get two => 0x02;
  static int get three => 0x04;
  static int get four => 0x08;
  static int get five => 0x10;
  static int get six => 0x20;
  static int get seven => 0x40;
  static int get eight => 0x80;

  static List<int> get values => [
    Relays.one,
    Relays.two,
    Relays.three,
    Relays.four,
    Relays.five,
    Relays.six,
    Relays.seven,
    Relays.eight,
  ];
}
