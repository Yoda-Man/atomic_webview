// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:universal_io/io.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'
    as webview_flutter_wkwebview;
import "/webview_desktop/webview_desktop.dart" as webview_desktop;

class WebViewLoadError {
  const WebViewLoadError({
    required this.description,
    this.code,
    this.url,
    this.isForMainFrame,
  });

  final String description;
  final int? code;
  final String? url;
  final bool? isForMainFrame;
}

class WebViewController {
  late final webview_desktop.Webview webview_desktop_controller;
  late final webview_flutter.WebViewController webview_mobile_controller;
  bool is_init = false;
  bool is_desktop =
      ((Platform.isLinux || Platform.isMacOS || Platform.isWindows) &&
      kIsWeb == false);
  bool is_mobile = (Platform.isAndroid || Platform.isIOS || kIsWeb);
  final Set<String> allowedSchemes;
  final void Function(Uri uri)? onNavigation;
  final void Function(WebViewLoadError error)? onLoadError;
  final List<File> _temporaryAssetFiles = [];

  WebViewController({
    Set<String> allowedSchemes = const {'http', 'https'},
    this.onNavigation,
    this.onLoadError,
  }) : allowedSchemes = allowedSchemes
           .map((scheme) => scheme.toLowerCase())
           .toSet();

  void validateUri(Uri uri) {
    if (!uri.hasScheme || !allowedSchemes.contains(uri.scheme.toLowerCase())) {
      throw ArgumentError.value(
        uri,
        'uri',
        'Allowed URI schemes: ${allowedSchemes.join(', ')}',
      );
    }
  }

  Future<Uri> createTemporaryAssetUri(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final safeName = assetPath
        .split('/')
        .last
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final directory = await Directory.systemTemp.createTemp(
      'atomic_webview_asset_',
    );
    final file = File('${directory.path}/$safeName');
    await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
    _temporaryAssetFiles.add(file);
    return file.uri;
  }

  Future<void> dispose() async {
    if (is_desktop && is_init) {
      await webview_desktop_controller.close();
    }
    for (final file in _temporaryAssetFiles) {
      try {
        final directory = file.parent;
        if (await directory.exists()) {
          await directory.delete(recursive: true);
        }
      } on FileSystemException {
        // A native WebView can retain the file briefly while shutting down.
      }
    }
    _temporaryAssetFiles.clear();
    is_init = false;
  }

  Future<void> init({
    required BuildContext context,
    required void Function(void Function() fn) setState,
    required Uri uri,
  }) async {
    if (is_init) {
      throw StateError('WebViewController.init may only be called once.');
    }
    validateUri(uri);
    if (is_mobile) {
      late final webview_flutter.PlatformWebViewControllerCreationParams params;
      if (webview_flutter.WebViewPlatform.instance
          is webview_flutter_wkwebview.WebKitWebViewPlatform) {
        params =
            webview_flutter_wkwebview.WebKitWebViewControllerCreationParams(
              allowsInlineMediaPlayback: true,
              mediaTypesRequiringUserAction:
                  const <webview_flutter_wkwebview.PlaybackMediaTypes>{},
            );
      } else {
        params =
            const webview_flutter.PlatformWebViewControllerCreationParams();
      }
      webview_mobile_controller =
          webview_flutter.WebViewController.fromPlatformCreationParams(params);
      if (!kIsWeb) {
        await webview_mobile_controller.setJavaScriptMode(
          webview_flutter.JavaScriptMode.unrestricted,
        );
        await webview_mobile_controller.setNavigationDelegate(
          webview_flutter.NavigationDelegate(
            onWebResourceError: (webview_flutter.WebResourceError error) {
              onLoadError?.call(
                WebViewLoadError(
                  description: error.description,
                  code: error.errorCode,
                  isForMainFrame: error.isForMainFrame,
                ),
              );
            },
            onNavigationRequest: (webview_flutter.NavigationRequest request) {
              final requestedUri = Uri.tryParse(request.url);
              if (requestedUri == null ||
                  !allowedSchemes.contains(requestedUri.scheme.toLowerCase())) {
                return webview_flutter.NavigationDecision.prevent;
              }
              onNavigation?.call(requestedUri);
              return webview_flutter.NavigationDecision.navigate;
            },
          ),
        );
      }
      await webview_mobile_controller.loadRequest(uri);
      is_init = true;
      setState(() {});
    } else if (is_desktop) {
      bool isWebviewAvailable =
          await webview_desktop.WebviewWindow.isWebviewAvailable();
      if (!isWebviewAvailable) {
        throw StateError(
          'The native WebView runtime is not available on this device.',
        );
      }
      webview_desktop_controller = await webview_desktop.WebviewWindow.create(
        configuration: webview_desktop.CreateConfiguration(
          titleBarTopPadding: Platform.isMacOS ? 20 : 0,
        ),
      );
      webview_desktop_controller.addOnUrlRequestCallback((url) {
        final requestedUri = Uri.tryParse(url);
        if (requestedUri != null) {
          onNavigation?.call(requestedUri);
        }
      });
      webview_desktop_controller.setOnNavigationErrorCallback((
        description,
        code,
        url,
      ) {
        onLoadError?.call(
          WebViewLoadError(description: description, code: code, url: url),
        );
      });
      await webview_desktop_controller.launch(uri.toString());
      is_init = true;
      setState(() {});
    }
  }
}
