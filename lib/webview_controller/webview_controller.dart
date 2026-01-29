import 'package:flutter/foundation.dart';
import 'webview_controller_web.dart';

export 'webview_controller_web.dart';

extension WebViewControllerExtension on WebViewController {
  void goBackSync() {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      webview_mobile_controller.goBack();
    }
    if (is_desktop) {
      webview_desktop_controller.back();
    }
  }

  void goForwardSync() async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      webview_mobile_controller.goForward();
    }
    if (is_desktop) {
      webview_desktop_controller.forward();
    }
  }

  void goSync({required Uri uri}) async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      webview_mobile_controller.loadRequest(uri);
    }
    if (is_desktop) {
      webview_desktop_controller.launch(uri.toString());
    }
  }

  Future<void> goBack() async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      await webview_mobile_controller.goBack();
    }
    if (is_desktop) {
      await webview_desktop_controller.back();
    }
  }

  Future<void> goForward() async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      await webview_mobile_controller.goForward();
    }
    if (is_desktop) {
      await webview_desktop_controller.forward();
    }
  }

  Future<void> go({required Uri uri}) async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      await webview_mobile_controller.loadRequest(uri);
    }
    if (is_desktop) {
      webview_desktop_controller.launch(uri.toString());
    }
  }

  Future<void> reload() async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      await webview_mobile_controller.reload();
    }
    if (is_desktop) {
      await webview_desktop_controller.reload();
    }
  }

  Future<void> stop() async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      await webview_mobile_controller.runJavaScript("window.stop();");
    }
    if (is_desktop) {
      await webview_desktop_controller.stop();
    }
  }

  Future<void> loadAsset(String assetPath) async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      if (!kIsWeb) {
        await webview_mobile_controller.loadFlutterAsset(assetPath);
      }
    }
    if (is_desktop) {
      // For desktop, we assume the user might need to handle the asset path or we can try a best-effort file:// load
      // however webview_window usually expects a full URL.
      // A common pattern is to use a local server or a file URI if supported.
      webview_desktop_controller.launch(Uri.file(assetPath).toString());
    }
  }

  Future<String?> evaluateJavaScript(String javaScript) async {
    if (is_init == false) {
      return null;
    }
    if (is_mobile) {
      return await webview_mobile_controller
          .runJavaScriptReturningResult(javaScript)
          .then((value) => value.toString());
    }
    if (is_desktop) {
      return await webview_desktop_controller.evaluateJavaScript(javaScript);
    }
    return null;
  }
}
