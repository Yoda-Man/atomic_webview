import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;
import "/webview_controller/webview_controller.dart" as webview_controller;

class WebView extends StatelessWidget {
  final webview_controller.WebViewController controller;

  const WebView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.is_init) {
      return const SizedBox.shrink();
    }
    if (controller.is_mobile) {
      return webview_flutter.WebViewWidget(
        controller: controller.webview_mobile_controller,
      );
    }
    if (controller.is_desktop) {
      return const Center(
        child: Text("WebView is running in a separate window"),
      );
    }
    return const SizedBox.shrink();
  }
}
