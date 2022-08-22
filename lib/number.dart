import 'dart:collection';

import 'package:flutter/material.dart';

class NumberPage extends StatefulWidget {
  final HashSet<String> set;

  const NumberPage({Key? key, required this.set}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NumberPageState();
}

class _NumberPageState extends State<NumberPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];

    for (var element in widget.set) {
      widgetList.add(Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          element,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Show phone number"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
          children: widgetList,
        ),
      ),
    );
  }
}
