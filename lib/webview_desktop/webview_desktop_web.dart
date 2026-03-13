import 'package:flutter/material.dart';

class Webview {
  void setBrightness(Brightness brightness) {}
  void launch(String url) {}
  Future<void> back() async {}
  Future<void> forward() async {}
  Future<void> reload() async {}
  Future<void> stop() async {}
  Future<String?> evaluateJavaScript(String javaScript) async => null;
  void close() {}
}

class WebviewWindow {
  static Future<bool> isWebviewAvailable() async {
    return false;
  }

  static Future<Webview> create({CreateConfiguration? configuration}) async {
    return Webview();
  }
}

class CreateConfiguration {
  final double titleBarTopPadding;
  CreateConfiguration({this.titleBarTopPadding = 0});
}
