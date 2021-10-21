import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../storage.dart';

class AddServer extends StatefulWidget {
  const AddServer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddServerState();
}

class _AddServerState extends State<AddServer> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    addressController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add server")),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double horizontal = constraints.maxWidth * 0.05;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: 0, bottom: 16, left: horizontal, right: horizontal),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Example Server',
                      labelText: "Server name"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 0, bottom: 16, left: horizontal, right: horizontal),
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Server address',
                      hintText: 'example.server.net'),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: 0, bottom: 16, left: horizontal, right: horizontal),
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        dynamic dialog;
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              dialog = context;
                              return AlertDialog(
                                  title: const Text('Saving server...'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const <Widget>[
                                      Center(
                                          child: SpinKitDualRing(
                                              color: Colors.green, size: 50.0))
                                    ],
                                  ));
                            });
                        await Storage.addServer(
                            nameController.text, addressController.text);
                        Navigator.pop(dialog);
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              dialog = context;
                              return AlertDialog(
                                title: const Text('Server saved!'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text(
                                        "The server has been added to the server list."),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            });
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add server")))
            ],
          );
        }));
  }
}
