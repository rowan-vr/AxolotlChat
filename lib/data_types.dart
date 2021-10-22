import 'dart:convert';
import 'dart:typed_data';

class VarInt {
  late int value;

  VarInt(int value) {
    this.value = value.toSigned(32);
  }

  factory VarInt.decode(Uint8List data) {
    int value = 0;
    int bitOffset = 0;
    int currentByte;
    int i = data.length - 1;
    do {
      currentByte = data[i];

      value |= (currentByte & 0x80) << bitOffset;

      bitOffset += 7;
      i--;
    } while ((currentByte & 0x80) != 0);
    return VarInt(value);
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

class VarLong {
  late int value;

  VarLong(int value) {
    this.value = value.toSigned(64);
  }

  factory VarLong.decode(Uint8List data) {
    int value = 0;
    int bitOffset = 0;
    int currentByte;
    do {
      currentByte = data.removeLast();

      value |= (currentByte & 0x80) << bitOffset;

      bitOffset += 7;
    } while ((currentByte & 0x80) != 0);
    return VarLong(value);
  }

  Uint8List get encodedVarLong {
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

  int get longValue {
    return value;
  }
}

class EncodedString {
  String? value;

  EncodedString(this.value);

  factory EncodedString.decode(Uint8List data) {
    var length = VarInt.decode(data.sublist(0, 4)).value;
    return EncodedString(utf8.decode(data.sublist(5, 5 + length)));
  }

  Uint8List get encodedString {
    if (value == null) return Uint8List(0);
    BytesBuilder builder = BytesBuilder();
    final stringData = utf8.encode(value!);
    builder.add(VarInt(stringData.length).encodedVarInt);
    builder.add(stringData);
    return builder.toBytes();
  }
}
