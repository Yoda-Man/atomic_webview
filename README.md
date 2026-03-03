# Atomic Webview

A powerful, cross-platform WebView for Flutter supporting Android, iOS, Linux, macOS, Web, and Windows with a single unified API.

## Platform Support

| Platform | Support | Engine |
|---|---|---|
| Android | ✅ | Android WebView (via `webview_flutter`) |
| iOS | ✅ | WKWebView (via `webview_flutter`) |
| Linux | ✅ | WebKitGTK (webkit2gtk-4.0 or 4.1) |
| macOS | ✅ | WKWebView (native) |
| Windows | ✅ | Microsoft WebView2 |
| Web | ✅ | Browser iframe |

## Features

- **Unified API**: One `WebViewController` works across all 6 platforms.
- **Navigation**: Load URLs, go back/forward, reload, and stop loading.
- **JavaScript**: Evaluate JavaScript and receive results.
- **Asset Loading**: Load local Flutter assets directly into the WebView.
- **Native Performance**: Uses each platform's native web engine.
- **Desktop Windows**: A separate native window with an optional Flutter-based title bar.

## Requirements

### Windows

Microsoft [WebView2 Runtime](https://developer.microsoft.com/en-us/microsoft-edge/webview2/) must be installed. It ships by default with Windows 11 and recent Windows 10 updates.

### Linux (Ubuntu / Debian)

Install the WebKitGTK development library. The plugin automatically detects which version is available:

```bash
# Ubuntu 22.04+ (preferred)
sudo apt install libwebkit2gtk-4.1-dev

# Ubuntu 20.04 / older systems
sudo apt install libwebkit2gtk-4.0-dev
```

### Android

Minimum SDK version 19. Enable cleartext traffic in `AndroidManifest.xml` if needed for non-HTTPS URLs:

```xml
<application android:usesCleartextTraffic="true" ...>
```

## Installation

Add `atomic_webview` to your `pubspec.yaml`:

```yaml
dependencies:
  atomic_webview: ^0.1.2
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:atomic_webview/atomic_webview.dart';

void main() {
  runApp(const MaterialApp(home: MyWebViewPage()));
}

class MyWebViewPage extends StatefulWidget {
  const MyWebViewPage({super.key});

  @override
  State<MyWebViewPage> createState() => _MyWebViewPageState();
}

class _MyWebViewPageState extends State<MyWebViewPage> {
  final WebViewController _controller = WebViewController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.init(
        context: context,
        setState: setState,
        uri: Uri.parse('https://flutter.dev'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atomic Webview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _controller.goBack(),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => _controller.goForward(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: WebView(controller: _controller),
    );
  }
}
```

> **Desktop Note**: On Linux, macOS, and Windows the WebView opens as a **separate native window**. The `WebView` widget in your Flutter app displays a placeholder text while the native window is open.

## API Reference

### Initialization

```dart
await controller.init(
  context: context,    // BuildContext – required
  setState: setState,  // Required to trigger UI rebuild after init
  uri: Uri.parse('https://example.com'),
);
```

### Navigation

```dart
// Navigate to a URL
await controller.go(uri: Uri.parse('https://example.com'));

// Synchronous variant (fire-and-forget)
controller.goSync(uri: Uri.parse('https://example.com'));

// Back / Forward
await controller.goBack();
await controller.goForward();

// Reload / Stop
await controller.reload();
await controller.stop();
```

### Loading Local Assets

```dart
// Load a Flutter asset (e.g. assets/index.html declared in pubspec.yaml)
await controller.loadAsset('assets/index.html');
```

### JavaScript

```dart
// Evaluate JS and get the result as a String
String? title = await controller.evaluateJavaScript('document.title');

// Run JS without needing the result
await controller.evaluateJavaScript('console.log("hello")');
```

### State Checks

```dart
bool ready       = controller.is_init;    // true after init() succeeds
bool onDesktop   = controller.is_desktop; // Linux / macOS / Windows
bool onMobile    = controller.is_mobile;  // Android / iOS / Web
```

### Desktop-Only: Advanced WebView API

On desktop platforms, `webview_desktop_controller` exposes additional native capabilities:

```dart
if (controller.is_desktop && controller.is_init) {
  final wv = controller.webview_desktop_controller;

  // Inject a script that runs at document creation
  wv.addScriptToExecuteOnDocumentCreated('window.myFlag = true;');

  // Set a custom user-agent suffix
  await wv.setApplicationNameForUserAgent('MyApp/1.0');

  // Listen for navigation events
  wv.setOnHistoryChangedCallback((canGoBack, canGoForward) {
    print('canGoBack=$canGoBack canGoForward=$canGoForward');
  });

  // Monitor URL changes
  wv.addOnUrlRequestCallback((url) => print('Navigating to $url'));

  // Open browser DevTools (Windows / macOS)
  await wv.openDevToolsWindow();

  // Post a message to a web page
  await wv.postWebMessageAsString('hello from Flutter');

  // Close the native window
  wv.close();

  // Wait for the window to close
  await wv.onClose;
}
```

## Desktop Title Bar

On desktop, a thin Flutter-powered title bar is displayed above the WebView. You can customise it in your app's `main()` with `runWebViewTitleBarWidget`:

```dart
import 'package:atomic_webview/atomic_webview.dart';

void main(List<String> args) {
  // If this process was launched as the title-bar sub-engine, handle it here.
  if (runWebViewTitleBarWidget(args)) return;

  runApp(const MyApp());
}
```

This allows your app to provide a fully custom title bar using the `TitleBarWebViewController` mixin and `TitleBarWebViewState` widget.

## Troubleshooting

| Problem | Solution |
|---|---|
| `MissingPluginException` on Windows | Ensure `WebView2 Runtime` is installed. Rebuild the app after adding the plugin. |
| `MissingPluginException` on Linux | Install `libwebkit2gtk-4.1-dev` (or `4.0-dev`) and rebuild. |
| Linux build error (`webkit_javascript_result_get_js_value`) | Update to v0.1.2+; the build system now auto-selects the correct WebKit API. |
| WebView shows placeholder on desktop | This is correct – on desktop the WebView is a separate native window. |
| Blank page on Android | Add `android:usesCleartextTraffic="true"` for HTTP URLs. |
