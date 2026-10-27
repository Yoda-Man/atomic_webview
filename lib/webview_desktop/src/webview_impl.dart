import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'webview.dart';

class WebviewImpl extends Webview {
  final int viewId;

  final MethodChannel channel;

  final Map<String, JavaScriptMessageHandler> _javaScriptMessageHandlers = {};

  bool _closed = false;

  PromptHandler? _promptHandler;

  final _closeCompleter = Completer<void>();

  OnHistoryChangedCallback? _onHistoryChanged;

  OnNavigationErrorCallback? _onNavigationError;

  final ValueNotifier<bool> _isNaivgating = ValueNotifier<bool>(false);

  final Set<OnUrlRequestCallback> _onUrlRequestCallbacks = {};

  final Set<OnWebMessageReceivedCallback> _onWebMessageReceivedCallbacks = {};

  WebviewImpl(this.viewId, this.channel);

  void _ensureOpen() {
    if (_closed) {
      throw StateError('WebView $viewId is already closed.');
    }
  }

  @override
  Future<void> get onClose => _closeCompleter.future;

  void onClosed() {
    if (_closed) {
      return;
    }
    _closed = true;
    _closeCompleter.complete();
  }

  void onJavaScriptMessage(String name, dynamic body) {
    _ensureOpen();
    final handler = _javaScriptMessageHandlers[name];
    assert(handler != null, "handler $name is not registed.");
    handler?.call(name, body);
  }

  String onRunJavaScriptTextInputPanelWithPrompt(
    String prompt,
    String defaultText,
  ) {
    _ensureOpen();
    return _promptHandler?.call(prompt, defaultText) ?? defaultText;
  }

  void onHistoryChanged(bool canGoBack, bool canGoForward) {
    _ensureOpen();
    _onHistoryChanged?.call(canGoBack, canGoForward);
  }

  void onNavigationStarted() {
    _isNaivgating.value = true;
  }

  void notifyUrlChanged(String url) {
    for (final callback in _onUrlRequestCallbacks) {
      callback(url);
    }
  }

  void notifyWebMessageReceived(String message) {
    for (final callback in _onWebMessageReceivedCallbacks) {
      callback(message);
    }
  }

  void onNavigationCompleted() {
    _isNaivgating.value = false;
  }

  void onNavigationError(String description, int? code, String? url) {
    _isNaivgating.value = false;
    _onNavigationError?.call(description, code, url);
  }

  @override
  ValueListenable<bool> get isNavigating => _isNaivgating;

  @override
  Future<void> registerJavaScriptMessageHandler(
    String name,
    JavaScriptMessageHandler handler,
  ) async {
    if (!Platform.isMacOS) {
      throw UnsupportedError(
        'JavaScript message handlers are only supported on macOS.',
      );
    }
    _ensureOpen();
    if (name.trim().isEmpty) {
      throw ArgumentError.value(name, 'name', 'Must not be empty.');
    }
    if (_javaScriptMessageHandlers.containsKey(name)) {
      throw StateError('JavaScript handler "$name" is already registered.');
    }
    _javaScriptMessageHandlers[name] = handler;
    await channel.invokeMethod("registerJavaScripInterface", {
      "viewId": viewId,
      "name": name,
    });
  }

  @override
  Future<void> unregisterJavaScriptMessageHandler(String name) async {
    if (!Platform.isMacOS) {
      throw UnsupportedError(
        'JavaScript message handlers are only supported on macOS.',
      );
    }
    if (_closed) {
      throw StateError('WebView $viewId is already closed.');
    }
    await channel.invokeMethod("unregisterJavaScripInterface", {
      "viewId": viewId,
      "name": name,
    });
    _javaScriptMessageHandlers.remove(name);
  }

  @override
  void setPromptHandler(PromptHandler? handler) {
    if (!Platform.isMacOS) {
      throw UnsupportedError('Prompt handlers are only supported on macOS.');
    }
    _promptHandler = handler;
  }

  @override
  Future<void> launch(String url) async {
    _ensureOpen();
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !const {'http', 'https', 'file'}.contains(uri.scheme.toLowerCase())) {
      throw ArgumentError.value(
        url,
        'url',
        'Desktop WebViews only allow http, https, and file URLs.',
      );
    }
    await channel.invokeMethod("launch", {"url": url, "viewId": viewId});
  }

  @override
  Future<void> setBrightness(Brightness? brightness) async {
    /// -1 : system default
    /// 0 : dark
    /// 1 : light
    if (!Platform.isMacOS) {
      throw UnsupportedError('Brightness is only supported on macOS.');
    }
    await channel.invokeMethod("setBrightness", {
      "viewId": viewId,
      "brightness": brightness?.index ?? -1,
    });
  }

  @override
  Future<void> addScriptToExecuteOnDocumentCreated(String javaScript) async {
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      return;
    }
    assert(javaScript.trim().isNotEmpty);
    await channel.invokeMethod("addScriptToExecuteOnDocumentCreated", {
      "viewId": viewId,
      "javaScript": javaScript,
    });
  }

  @override
  Future<void> setApplicationNameForUserAgent(String applicationName) async {
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      return;
    }
    await channel.invokeMethod("setApplicationNameForUserAgent", {
      "viewId": viewId,
      "applicationName": applicationName,
    });
  }

  @override
  Future<void> forward() {
    return channel.invokeMethod("forward", {"viewId": viewId});
  }

  @override
  Future<void> back() {
    return channel.invokeMethod("back", {"viewId": viewId});
  }

  @override
  Future<void> reload() {
    return channel.invokeMethod("reload", {"viewId": viewId});
  }

  @override
  Future<void> stop() {
    return channel.invokeMethod("stop", {"viewId": viewId});
  }

  @override
  Future<void> openDevToolsWindow() {
    return channel.invokeMethod('openDevToolsWindow', {"viewId": viewId});
  }

  @override
  void setOnHistoryChangedCallback(OnHistoryChangedCallback? callback) {
    _onHistoryChanged = callback;
  }

  @override
  void setOnNavigationErrorCallback(OnNavigationErrorCallback? callback) {
    _onNavigationError = callback;
  }

  @override
  void addOnUrlRequestCallback(OnUrlRequestCallback callback) {
    _onUrlRequestCallbacks.add(callback);
  }

  @override
  void removeOnUrlRequestCallback(OnUrlRequestCallback callback) {
    _onUrlRequestCallbacks.remove(callback);
  }

  @override
  void addOnWebMessageReceivedCallback(OnWebMessageReceivedCallback callback) {
    _onWebMessageReceivedCallbacks.add(callback);
  }

  @override
  void removeOnWebMessageReceivedCallback(
    OnWebMessageReceivedCallback callback,
  ) {
    _onWebMessageReceivedCallbacks.remove(callback);
  }

  @override
  Future<void> close() async {
    if (_closed) {
      return;
    }
    await channel.invokeMethod("close", {"viewId": viewId});
  }

  @override
  Future<String?> evaluateJavaScript(String javaScript) async {
    final dynamic result = await channel.invokeMethod("evaluateJavaScript", {
      "viewId": viewId,
      "javaScriptString": javaScript,
    });
    if (result is String || result == null) {
      return result;
    }
    return json.encode(result);
  }

  @override
  Future<void> postWebMessageAsString(String webMessage) async {
    return channel.invokeMethod("postWebMessageAsString", {
      "viewId": viewId,
      "webMessage": webMessage,
    });
  }

  @override
  Future<void> postWebMessageAsJson(String webMessage) async {
    return channel.invokeMethod("postWebMessageAsJson", {
      "viewId": viewId,
      "webMessage": webMessage,
    });
  }
}
