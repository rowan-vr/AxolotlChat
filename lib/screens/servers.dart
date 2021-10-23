import 'package:axolotlchat/functions/ping_server.dart';
import 'package:axolotlchat/packet/packets/response_packet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:overlay_support/overlay_support.dart';

import '../storage.dart';
import 'add_server.dart';

class ServersScreen extends StatefulWidget {
  const ServersScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ServerState();
}

class ServerState extends State<ServersScreen> {
  late Map<String, ServerEntry> serverList;
  int state = 0;

  Future loadServers() async {
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
    loadServers();
  }

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case 0:
        return _loadingWidget(context);
      case 1:
        return _noServerWidget(context);
      case 2:
        return OverlaySupport(child: _serverListWidget(context));
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
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddServer()));
                            loadServers();
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
        elements.add(InkWell(
            onTap: serverList[name]?.pinging as bool
                ? () {
                    showSimpleNotification(
                      const Text("Server still pinging..."),
                      background: Colors.black26,
                    );
                  }
                : () {
                    showDialog(
                        builder: (BuildContext context) {
                          return _joinServerWidget(
                              serverList[name] as ServerEntry);
                        },
                        context: context);
                  },
            child: ConstrainedBox(
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
                                : ((serverList[name]?.failed as bool)
                                    ? Text("Could not connect to this server.",
                                        style:
                                            TextStyle(color: Colors.red[900]))
                                    : Text(serverList[name]
                                        ?.data
                                        .description
                                        .text as String)),
                          )
                        ])))));
        elements.add(ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 2,
                maxHeight: 2,
                minWidth: constraints.maxWidth,
                maxWidth: constraints.maxWidth),
            child: Container(color: Colors.grey[800])));

        if (serverList[name]?.pinging as bool) {
          _pingEntry(serverList[name] as ServerEntry);
        }
      }

          return Scaffold(
              appBar: AppBar(title: const Text("My Servers")),
              body: SingleChildScrollView(child: Column(children: elements)),
              floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddServer()));
              loadServers();
            },
            tooltip: 'Add Server',
            child: const Icon(Icons.add),
          ));
    });
  }

  Widget _joinServerWidget(ServerEntry entry) {
    if (entry.failed) {
      return AlertDialog(
        title: Text(entry.name,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                  const TextSpan(
                      text: "Address: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: entry.address)
                ])),
            RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.red[900]),
                    children: const [
                  TextSpan(
                      text: "Error: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "Could not connect to this server.")
                ]))
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _deleteDialog(entry, context);
                  });
            },
            child: Text('Delete', style: TextStyle(color: Colors.red[900])),
          ),
          const ElevatedButton(
            onPressed: null,
            child: Text('Join'),
          )
        ],
      );
    } else {
      return AlertDialog(
        title: Text(entry.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                  const TextSpan(
                      text: "Address: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: entry.address)
                ])),
            RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                  const TextSpan(
                      text: "Version: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: entry.data.version.name)
                ])),
            RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                  const TextSpan(
                      text: "Players: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: entry.data.players.online.toString() +
                          "/" +
                          entry.data.players.max.toString())
                ]))
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _deleteDialog(entry, context);
                  });
            },
            child: Text('Delete', style: TextStyle(color: Colors.red[900])),
          ),
          const ElevatedButton(
            onPressed: null,
            child: Text('Join'),
          )
        ],
      );
    }
  }

  Widget _deleteDialog(ServerEntry entry, BuildContext context) {
    return AlertDialog(
      title: Text("Delete " + entry.name,
          style: TextStyle(color: Colors.red[900])),
      content: Text("Are you sure you want to delete '" + entry.name + "'?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("No", style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
            onPressed: () {},
            child: const Text("Yes"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)))
      ],
    );
  }

  void _pingEntry(ServerEntry entry) async {
    try {
      final response = await ping(entry.address);
      setState(() {
        entry.pinging = false;
        entry.data = response?.response as ServerResponse;
      });
    } on PingException {
      setState(() {
        entry.pinging = false;
        entry.failed = true;
      });
    }
  }
}

class ServerEntry {
  String address;
  String name;
  bool pinging;
  bool failed = false;
  late String ping;
  late ServerResponse data;

  ServerEntry(this.address, this.name, this.pinging);
}
