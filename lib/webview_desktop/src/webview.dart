import 'package:flutter/foundation.dart';

/// Handle custom message from JavaScript in your app.
typedef JavaScriptMessageHandler = void Function(String name, dynamic body);

typedef PromptHandler = String Function(String prompt, String defaultText);

typedef OnHistoryChangedCallback =
    void Function(bool canGoBack, bool canGoForward);

/// Callback when WebView start to load a URL.
/// [url] is the URL string.
typedef OnUrlRequestCallback = void Function(String url);

/// Callback when WebView receives a web message
/// [message] constains the webmessage
typedef OnWebMessageReceivedCallback = void Function(String message);

typedef OnNavigationErrorCallback =
    void Function(String description, int? code, String? url);

abstract class Webview {
  Future<void> get onClose;

  ///  true if the webview is currently loading a page.
  ValueListenable<bool> get isNavigating;

  /// Install a message handler that you can call from your Javascript code.
  ///
  /// available: macOS (10.10+)
  Future<void> registerJavaScriptMessageHandler(
    String name,
    JavaScriptMessageHandler handler,
  );

  /// available: macOS
  Future<void> unregisterJavaScriptMessageHandler(String name);

  /// available: macOS
  void setPromptHandler(PromptHandler? handler);

  /// Navigates to the given URL.
  Future<void> launch(String url);

  /// change webview theme.
  ///
  /// available only: macOS (Brightness.dark only 10.14+)
  Future<void> setBrightness(Brightness? brightness);

  Future<void> addScriptToExecuteOnDocumentCreated(String javaScript);

  /// Append a string to the webview's user-agent.
  Future<void> setApplicationNameForUserAgent(String applicationName);

  /// Navigate to the previous page in the history.
  Future<void> back();

  /// Navigate to the next page in the history.
  Future<void> forward();

  /// Reload the current page.
  Future<void> reload();

  /// Stop all navigations and pending resource fetches.
  Future<void> stop();

  /// Opens the Browser DevTools in a separate window on Windows.
  ///
  /// Throws an `unsupported` [PlatformException] on macOS and Linux.
  Future<void> openDevToolsWindow();

  /// Register a callback that will be invoked when the webview history changes.
  void setOnHistoryChangedCallback(OnHistoryChangedCallback? callback);

  /// Registers the callback used for main-frame navigation failures.
  void setOnNavigationErrorCallback(OnNavigationErrorCallback? callback);

  void addOnUrlRequestCallback(OnUrlRequestCallback callback);

  void removeOnUrlRequestCallback(OnUrlRequestCallback callback);

  void addOnWebMessageReceivedCallback(OnWebMessageReceivedCallback callback);

  void removeOnWebMessageReceivedCallback(
    OnWebMessageReceivedCallback callback,
  );

  /// Close the web view window.
  Future<void> close();

  /// evaluate JavaScript in the web view.
  Future<String?> evaluateJavaScript(String javaScript);

  /// Posts a web message as a string on Windows.
  ///
  /// Throws an `unsupported` [PlatformException] on macOS and Linux.
  Future<void> postWebMessageAsString(String webMessage);

  /// Posts a web message as JSON on Windows.
  ///
  /// Throws an `unsupported` [PlatformException] on macOS and Linux.
  Future<void> postWebMessageAsJson(String webMessage);
}
