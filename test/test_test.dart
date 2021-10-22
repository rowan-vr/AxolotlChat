// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:typed_data';

import 'package:axolotlchat/data_types.dart';
import 'package:test/test.dart';

void main() {
  //testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //  // Build our app and trigger a frame.
  //  await tester.pumpWidget(const AxolotlChat());
//
  //  // Verify that our counter starts at 0.
  //  expect(find.text('0'), findsOneWidget);
  //  expect(find.text('1'), findsNothing);
//
  //  // Tap the '+' icon and trigger a frame.
  //  await tester.tap(find.byIcon(Icons.add));
  //  await tester.pump();
//
  //  // Verify that our counter has incremented.
  //  expect(find.text('0'), findsNothing);
  //  expect(find.text('1'), findsOneWidget);
  //});

  test('Test VarInt', () {
    late Uint8List byteList;

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

    byteList = VarInt(-1).encodedVarInt;
    expect(
        byteList.length == 5 &&
            byteList[0] == 0xff &&
            byteList[1] == 0xff &&
            byteList[2] == 0xff &&
            byteList[3] == 0xff &&
            byteList[4] == 0x0f,
        true);

    byteList = VarInt(-2147483648).encodedVarInt;
    expect(
        byteList.length == 5 &&
            byteList[0] == 0x80 &&
            byteList[1] == 0x80 &&
            byteList[2] == 0x80 &&
            byteList[3] == 0x80 &&
            byteList[4] == 0x08,
        true);
  });
}
