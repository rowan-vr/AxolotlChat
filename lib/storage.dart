import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Storage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _serverList async {
    final path = await _localPath;
    return File('$path/servers.json');
  }

  static Future<Map<String, dynamic>> get savedServers async {
    File file = await _serverList;
    if (file.existsSync()) {
      String content = await file.readAsString();
      Map<String, dynamic> servers = jsonDecode(content);
      return servers;
    }
    return {};
  }

  static Future addServer(String name, String address) async {
    File file = await _serverList;
    Map<String, dynamic> servers = {};
    if (file.existsSync()) {
      String content = await file.readAsString();
      servers = jsonDecode(content);
    } else {
      file.createSync();
    }
    servers[name] = address;
    await file.writeAsString(jsonEncode(servers));
    return;
  }

  static Future removeServer(String name) async {
    File file = await _serverList;
    Map<String, dynamic> servers = {};
    if (file.existsSync()) {
      String content = await file.readAsString();
      servers = jsonDecode(content);
      servers.remove(name);
      await file.writeAsString(jsonEncode(servers));
    }
    return;
  }
}
