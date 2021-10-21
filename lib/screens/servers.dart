import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_server.dart';

class ServersScreen extends StatefulWidget {
  const ServersScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoServerState();
}

class _NoServerState extends State<ServersScreen> {
  @override
  Widget build(BuildContext context) {
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
            ])
            /*ConstrainedBox(constraints: const BoxConstraints(minHeight: 100,maxHeight: 100),
          child: Container(color: Colors.grey[200],
              child: const Center(child: Text("You don't have any servers added! Add one now."))
          )),*/

            ));
  }
}


