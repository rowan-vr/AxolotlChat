import 'dart:typed_data';

class VarInt {
  late int value;

  VarInt(int value) {
    this.value = value.toSigned(32);
  }

  Uint8List get encodedVarInt {
    BytesBuilder builder = BytesBuilder();
    while (true) {
      int temp = (value & 0x7F).toUnsigned(8);
      value >>= 7;
      if (value != 0) {
        temp |= 0x80;
      }
      builder.addByte(temp);
      if (value == 0) {
        return builder.toBytes();
      }
    }
  }

  int get intValue {
    return value;
  }
}
