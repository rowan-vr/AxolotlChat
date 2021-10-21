import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../storage.dart';
import 'add_server.dart';

class ServersScreen extends StatefulWidget {
  const ServersScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ServerState();
}

class _ServerState extends State<ServersScreen> {
  late Map<String, ServerEntry> serverList;
  int state = 0;

  Future _loadServers() async {
    var _serverList = await Storage.savedServers;
    serverList = {};
    for (String name in _serverList.keys) {
      serverList[name] = ServerEntry(_serverList[name], name, true);
    }

    setState(() {
      state = (serverList.isNotEmpty) ? 2 : 1;
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    _loadServers();
  }

  @override
  Widget build(BuildContext context) {
    print(state);
    switch (state) {
      case 0:
        return _loadingWidget(context);
      case 1:
        return _noServerWidget(context);
      case 2:
        return _serverListWidget(context);
      default:
        return _noServerWidget(context);
    }
  }

  Widget _loadingWidget(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My Servers")),
        body: const Center(
            child: SpinKitDualRing(color: Colors.green, size: 50.0)));
  }

  Widget _noServerWidget(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My Servers")),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const Text("You don't have any servers added."),
              FittedBox(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddServer()));
                      },
                      child: const Center(child: Text("Add server"))))
            ])));
  }

  Widget _serverListWidget(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      List<Widget> elements = List.empty(growable: true);

      elements.add(ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: 2,
              maxHeight: 2,
              minWidth: constraints.maxWidth,
              maxWidth: constraints.maxWidth),
          child: Container(color: Colors.grey[800])));

      for (final String name in serverList.keys) {
        elements.add(ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 75,
                maxHeight: 75,
                minWidth: constraints.maxWidth,
                maxWidth: constraints.maxWidth),
            child: Container(
                color: Colors.grey[200],
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 4),
                        child: Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 4),
                        child: serverList[name]?.pinging as bool
                            ? Text("Pinging server...",
                                style: TextStyle(color: Colors.grey[900]))
                            : Text(serverList[name]?.motd as String),
                      )
                    ]))));
        elements.add(ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 2,
                maxHeight: 2,
                minWidth: constraints.maxWidth,
                maxWidth: constraints.maxWidth),
            child: Container(color: Colors.grey[800])));
      }

      return Scaffold(
          appBar: AppBar(title: const Text("My Servers")),
          body: Column(children: elements),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddServer()));
            },
            tooltip: 'Add Server',
            child: const Icon(Icons.add),
          ));
    });
  }
}

class ServerEntry {
  String address;
  String name;
  bool pinging;
  late String motd;
  late String ping;

  ServerEntry(this.address, this.name, this.pinging);
}
