# Atomic Webview

Atomic Webview is cross platform webview for android, ios, linux, macos, web, windows


## Tested On 
 
| OS      | Tested     |
|---------|------------|
| Android | Tested     |
| Linux   | Tested     |
| Windows | Tested     |
| ios     | Not Tested |
| Web     | Tested     |
| macOS   | Not Tested |


```dart
import 'package:flutter/material.dart';
import "package:webview_universal/webview_universal.dart";

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