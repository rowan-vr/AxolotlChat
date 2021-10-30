import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'screens/servers.dart';

void main() {
  runApp(const AxolotlChat());
}

class AxolotlChat extends StatelessWidget {
  const AxolotlChat({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: MaterialApp(
            title: 'Axolotl Chat | The modern minecraft chat client.',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: const ServersScreen()));
  }
}
