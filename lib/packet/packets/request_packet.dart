/* This file is adapted from 'https://github.com/spnda/dart_minecraft' authored by spnda licensed under MIT */

import '../packet_reader.dart';
import '../packet_writer.dart';
import 'server_packet.dart';

/// Packet without any fields indicating that the
/// client is requesting basic server information.
class RequestPacket extends ServerPacket {
  RequestPacket();

  @override
  int get getID => 0;

  @override
  Future<bool> read(PacketReader reader) async {
    return true;
  }

  @override
  void writePacket(PacketWriter writer) {}

  @override
  ServerPacket clone() {
    throw UnsupportedError('clone() is not supported on serverbound packets.');
  }
}
