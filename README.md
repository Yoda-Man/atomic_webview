# Atomic Webview

Atomic Webview is cross platform webview for android, ios, linux, macos, web, windows

## Ubuntu
on Ubuntu run the command "sudo apt install libwebkit2gtk-4.0-dev"


## Tested On 
 
early stages of development.

```dart
import 'package:flutter/material.dart';
import "package:atomic_webview/atomic_webview.dart";

void main(List<String> args) {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WebViewController webViewController = WebViewController();

  @override
  void initState() {
    super.initState();
    task();
  }

  Future<void> task() async {
    await webViewController.init(
      context: context,
      uri: Uri.parse("https://flutter.dev"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        controller: webViewController,
      ),
    );
  }
}

```