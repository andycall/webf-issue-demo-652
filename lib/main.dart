/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:webf/webf.dart';
import 'package:webf/devtools.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kraken Browser',
      // theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: FirstPage(title: 'Landing Bay'),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return FirstPageState();
  }
}

class FirstPageState extends State<FirstPage> {
  late WebFController controller;

  WebFJavaScriptChannel javaScriptChannel = WebFJavaScriptChannel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = WebFController(
      context,
      methodChannel: javaScriptChannel,
      devToolsService: ChromeDevToolsService(),
    );
    controller.preload(WebFBundle.fromUrl('assets:assets/bundle.html'));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return WebFDemo(controller: controller, javaScriptChannel: javaScriptChannel);
            }));
          },
          child: const Text('Open WebF Page'),
        ),
      ),
    );
  }
}

class WebFDemo extends StatefulWidget {
  final WebFController controller;
  final WebFJavaScriptChannel javaScriptChannel;

  WebFDemo({required this.controller, required this.javaScriptChannel});

  @override
  State<StatefulWidget> createState() {
    return WebFDemoState();
  }
}

class WebFDemoState extends State<WebFDemo> {
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    widget.javaScriptChannel.onMethodCall = (method, args) async {
      if (method == 'submitMap') {
        showLoading();
      }
    };
  }

  void showLoading() async {
    setState(() {
      isLoading = true;  // Show the spinner before the task starts
    });

    await Future.delayed(Duration(seconds: 2));  // Simulating a delay

    setState(() {
      isLoading = false;  // Hide the spinner after the task completes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WebF Demo'),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: isLoading ? CircularProgressIndicator() : WebF(controller: widget.controller),
        ));
  }
}
