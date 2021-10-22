// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:test/test.dart';

void main() {

  test('Test VarInt Encode', () {
    /*late Uint8List byteList;

    byteList = VarInt(0).encodedVarInt;
    expect(byteList.length == 1 && byteList.first == 0x00, true);

    byteList = VarInt(1).encodedVarInt;
    expect(byteList.length == 1 && byteList.first == 0x01, true);

    byteList = VarInt(2).encodedVarInt;
    expect(byteList.length == 1 && byteList.first == 0x02, true);

    byteList = VarInt(127).encodedVarInt;
    expect(byteList.length == 1 && byteList.first == 0x7F, true);

    byteList = VarInt(128).encodedVarInt;
    expect(byteList.length == 2 && byteList[0] == 0x80 && byteList[1] == 0x01,
        true);

    byteList = VarInt(255).encodedVarInt;
    expect(byteList.length == 2 && byteList[0] == 0xff && byteList[1] == 0x01,
        true);

    byteList = VarInt(25565).encodedVarInt;
    expect(
        byteList.length == 3 &&
            byteList[0] == 0xdd &&
            byteList[1] == 0xc7 &&
            byteList[2] == 0x01,
        true);

    byteList = VarInt(2097151).encodedVarInt;
    expect(
        byteList.length == 3 &&
            byteList[0] == 0xff &&
            byteList[1] == 0xff &&
            byteList[2] == 0x7f,
        true);

    byteList = VarInt(2147483647).encodedVarInt;
    expect(
        byteList.length == 5 &&
            byteList[0] == 0xff &&
            byteList[1] == 0xff &&
            byteList[2] == 0xff &&
            byteList[3] == 0xff &&
            byteList[4] == 0x07,
        true);

    //byteList = VarInt(-1).encodedVarInt;
    //expect(
    //    byteList.length == 5 &&
    //        byteList[0] == 0xff &&
    //        byteList[1] == 0xff &&
    //        byteList[2] == 0xff &&
    //        byteList[3] == 0xff &&
    //        byteList[4] == 0x0f,
    //    true);

    //byteList = VarInt(-2147483648).encodedVarInt;
    //expect(
    //    byteList.length == 5 &&
    //        byteList[0] == 0x80 &&
    //        byteList[1] == 0x80 &&
    //        byteList[2] == 0x80 &&
    //        byteList[3] == 0x80 &&
    //        byteList[4] == 0x08,
    //    true);*/
  });

  test('Test VarInt Decode', () {
    /* Uint8List byteList;

    byteList = Uint8List(1);
    byteList[0] = 0x00;
    expect(VarInt.decode(byteList).value, 0);

    byteList = Uint8List(1);
    byteList[0] = 0x01;
    expect(VarInt.decode(byteList).value, 1);

    byteList = Uint8List(1);
    byteList[0] = 0x02;
    expect(VarInt.decode(byteList).value, 2);

    byteList = Uint8List(1);
    byteList[0] = 0x7f;
    expect(VarInt.decode(byteList).value, 127);

    byteList = Uint8List(2);
    byteList[0] = 0x80;
    byteList[1] = 0x01;
    expect(VarInt.decode(byteList).value, 128);

    byteList = Uint8List(3);
    byteList[0] = 0xff;
    byteList[1] = 0xff;
    byteList[2] = 0x7f;

    expect(VarInt.decode(byteList).value, 2097151);
    */
  });
}
