/* Partitions of this code is adapted from 'https://github.com/spnda/dart_minecraft' authored by spnda licensed under MIT */

import 'dart:io';

import 'package:axolotlchat/packet/packet_reader.dart';
import 'package:axolotlchat/packet/packet_writer.dart';
import 'package:axolotlchat/packet/packets/handshake_packet.dart';
import 'package:axolotlchat/packet/packets/ping_packet.dart';
import 'package:axolotlchat/packet/packets/pong_packet.dart';
import 'package:axolotlchat/packet/packets/request_packet.dart';
import 'package:axolotlchat/packet/packets/response_packet.dart';
import 'package:axolotlchat/packet/packets/server_packet.dart';

void _writePacket(Socket socket, ServerPacket packet) async {
  final packetEncoded = PacketWriter.create().writePacket(packet);
  socket.add(packetEncoded);
}

int _now() => DateTime.now().millisecondsSinceEpoch;

Future<ResponsePacket?> ping(String serverUri,
    {int port = 25565, Duration timeout = const Duration(seconds: 30)}) async {
  try {
    // Register the packets we will require
    ServerPacket.registerClientboundPacket(ResponsePacket());
    ServerPacket.registerClientboundPacket(PongPacket());

    final socket = await Socket.connect(serverUri, port, timeout: timeout);
    final stream = socket.asBroadcastStream();

    _writePacket(socket, HandshakePacket(serverAddress: serverUri));
    _writePacket(socket, RequestPacket());

    final responsePacket =
        await PacketReader.readPacketFromStream(stream) as ResponsePacket;

    final pingPacket = PingPacket(_now());
    _writePacket(socket, pingPacket);
    final pongPacket =
        await PacketReader.readPacketFromStream(stream) as PongPacket;

    await socket.close();
    var ping = pongPacket.value! - pingPacket.value;

    /// If the ping is 0, we'll instead use the time it took
    /// for the server to respond and the packet returning back home.
    if (ping <= 0) {
      ping = _now() - pingPacket.value;
    }
    return responsePacket..ping = ping;
  } on SocketException {
    throw PingException('Could not connect to $serverUri');
  } on RangeError {
    throw PingException('Server sent unexpected data');
  }
}

class PingException implements Exception {
  final String message;

  PingException(this.message);

  @override
  String toString() {
    return 'PingException: $message';
  }
}
