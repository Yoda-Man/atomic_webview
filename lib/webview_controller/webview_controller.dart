import 'dart:async';

import 'package:flutter/foundation.dart';
import 'webview_controller_web.dart';

export 'webview_controller_web.dart';

extension WebViewControllerExtension on WebViewController {
  Never _notInitialized() {
    throw StateError('WebViewController.init must complete before use.');
  }

  void _reportAsyncError(Object error, StackTrace stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'atomic_webview',
      ),
    );
  }

  void _runUnawaited(Future<void> operation) {
    unawaited(operation.catchError(_reportAsyncError));
  }

  void goBackSync() {
    if (is_init == false) {
      _notInitialized();
    }
    if (is_mobile) {
      _runUnawaited(webview_mobile_controller.goBack());
    }
    if (is_desktop) {
      _runUnawaited(webview_desktop_controller.back());
    }
  }

  void goForwardSync() {
    if (is_init == false) {
      _notInitialized();
    }
    if (is_mobile) {
      _runUnawaited(webview_mobile_controller.goForward());
    }
    if (is_desktop) {
      _runUnawaited(webview_desktop_controller.forward());
    }
  }

  void goSync({required Uri uri}) {
    if (is_init == false) {
      _notInitialized();
    }
    validateUri(uri);
    if (is_mobile) {
      _runUnawaited(webview_mobile_controller.loadRequest(uri));
    }
    if (is_desktop) {
      _runUnawaited(webview_desktop_controller.launch(uri.toString()));
    }
  }

  Future<void> goBack() async {
    if (is_init == false) {
      _notInitialized();
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
      _notInitialized();
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
      _notInitialized();
    }
    validateUri(uri);
    if (is_mobile) {
      await webview_mobile_controller.loadRequest(uri);
    }
    if (is_desktop) {
      await webview_desktop_controller.launch(uri.toString());
    }
  }

  Future<void> reload() async {
    if (is_init == false) {
      _notInitialized();
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
      _notInitialized();
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
      _notInitialized();
    }
    if (is_mobile) {
      if (kIsWeb) {
        throw UnsupportedError('loadAsset is not supported on Web.');
      }
      await webview_mobile_controller.loadFlutterAsset(assetPath);
    }
    if (is_desktop) {
      final assetUri = await createTemporaryAssetUri(assetPath);
      await webview_desktop_controller.launch(assetUri.toString());
    }
  }

  Future<String?> evaluateJavaScript(String javaScript) async {
    if (is_init == false) {
      _notInitialized();
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
