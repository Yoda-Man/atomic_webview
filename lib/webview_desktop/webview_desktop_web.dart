import 'package:flutter/material.dart';

class Webview {
  void setBrightness(Brightness brightness) {}
  void launch(String url) {}
}

class WebviewWindow {
  static Future<bool> isWebviewAvailable() async {
    return false;
  }

  static Future<Webview> create({
    required CreateConfiguration configuration,
  }) async {
    return Webview();
  }
}

class CreateConfiguration {
  final double titleBarTopPadding;
  CreateConfiguration({required this.titleBarTopPadding});
}
