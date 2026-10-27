import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/webview.dart';

class Webview {
  final ValueNotifier<bool> _isNavigating = ValueNotifier(false);

  Future<void> get onClose => Future.value();
  ValueListenable<bool> get isNavigating => _isNavigating;

  Future<void> setBrightness(Brightness? brightness) async {}
  Future<void> launch(String url) async {}
  Future<void> back() async {}
  Future<void> forward() async {}
  Future<void> reload() async {}
  Future<void> stop() async {}
  Future<String?> evaluateJavaScript(String javaScript) async => null;
  Future<void> close() async {}
  Future<void> openDevToolsWindow() async => _unsupported();
  Future<void> postWebMessageAsString(String message) async => _unsupported();
  Future<void> postWebMessageAsJson(String message) async => _unsupported();
  Future<void> setApplicationNameForUserAgent(String applicationName) async {}
  Future<void> addScriptToExecuteOnDocumentCreated(String javaScript) async {}
  Future<void> registerJavaScriptMessageHandler(
    String name,
    JavaScriptMessageHandler handler,
  ) async {}
  Future<void> unregisterJavaScriptMessageHandler(String name) async {}
  void setPromptHandler(PromptHandler? handler) {}
  void setOnHistoryChangedCallback(OnHistoryChangedCallback? callback) {}
  void setOnNavigationErrorCallback(OnNavigationErrorCallback? callback) {}
  void addOnUrlRequestCallback(OnUrlRequestCallback callback) {}
  void removeOnUrlRequestCallback(OnUrlRequestCallback callback) {}
  void addOnWebMessageReceivedCallback(OnWebMessageReceivedCallback callback) {}
  void removeOnWebMessageReceivedCallback(
    OnWebMessageReceivedCallback callback,
  ) {}

  Never _unsupported() {
    throw UnsupportedError('This desktop WebView API is unavailable on Web.');
  }
}

class WebviewWindow {
  static Future<bool> isWebviewAvailable() async => false;

  static Future<Webview> create({CreateConfiguration? configuration}) async {
    throw UnsupportedError('Desktop WebView windows are unavailable on Web.');
  }
}

class CreateConfiguration {
  final double titleBarTopPadding;
  CreateConfiguration({this.titleBarTopPadding = 0});
}

bool runWebViewTitleBarWidget(
  List<String> args, {
  WidgetBuilder? builder,
  Color? backgroundColor,
  void Function(Object error, StackTrace stack)? onError,
}) => false;

mixin TitleBarWebViewController {
  static TitleBarWebViewController of(BuildContext context) {
    throw UnsupportedError('Desktop title bars are unavailable on Web.');
  }

  void back() {}
  void forward() {}
  void reload() {}
  void stop() {}
  void close() {}
}

class TitleBarWebViewState extends InheritedWidget {
  const TitleBarWebViewState({
    super.key,
    required super.child,
    required this.isLoading,
    required this.canGoBack,
    required this.canGoForward,
    required this.url,
  });

  final bool isLoading;
  final bool canGoBack;
  final bool canGoForward;
  final String? url;

  static TitleBarWebViewState of(BuildContext context) {
    throw UnsupportedError('Desktop title bars are unavailable on Web.');
  }

  @override
  bool updateShouldNotify(TitleBarWebViewState oldWidget) => false;
}
