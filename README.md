# Atomic Webview

A powerful, cross-platform WebView for Flutter that seamlessly supports Android, iOS, Linux, macOS, Web, and Windows.

## Features

*   **Truly Cross-Platform**: Write once, run everywhere. Consistent WebView experience across all 6 supported platforms.
*   **Unified Controller**: Control navigations, evaluate JavaScript, and load assets using a single `WebViewController`.
*   **Native Performance**: Leverages underlying native web technologies (WebKit, WebView2, etc.) for optimal performance.
*   **Asset Loading**: Easily load local Flutter assets across all platforms.

## Platform Support

| Platform | Support | Status |
|---|---|---|
| Android | ✅ | Supported |
| iOS | ✅ | Supported |
| Linux | ✅ | Supported |
| macOS | ✅ | Supported |
| Windows | ✅ | Supported |
| Web | ✅ | Supported |

### Installation

Add `atomic_webview` to your `pubspec.yaml`:

```yaml
dependencies:
  atomic_webview: ^0.1.1
```

## Requirements

### Linux (Ubuntu/Debian)

To run on Linux, you must install the WebKit2GTK development library:

```bash
sudo apt install libwebkit2gtk-4.0-dev # Or libwebkit2gtk-4.1-dev
```

## Usage Example

Here's how to integrate `AtomicWebview` into your Flutter application:

```dart
import 'package:flutter/material.dart';
import 'package:atomic_webview/atomic_webview.dart';

void main() {
  runApp(const MaterialApp(home: WebViewExampleApp()));
}

class WebViewExampleApp extends StatefulWidget {
  const WebViewExampleApp({super.key});

  @override
  State<WebViewExampleApp> createState() => _WebViewExampleAppState();
}

class _WebViewExampleAppState extends State<WebViewExampleApp> {
  // Create a WebViewController
  final WebViewController _webViewController = WebViewController();

  @override
  void initState() {
    super.initState();
    // Initialize the WebView after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _webViewController.init(
        context: context,
        setState: setState, // Required to update the UI after initialization
        uri: Uri.parse("https://flutter.dev"),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atomic Webview Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _webViewController.reload(),
          ),
        ],
      ),
      body: WebView(
        controller: _webViewController,
      ),
    );
  }
}
```

## Advanced Usage

### Loading Local Assets
```dart
await _webViewController.loadAsset('assets/index.html');
```

### Evaluating JavaScript
```dart
String? result = await _webViewController.evaluateJavaScript('document.title');
print('Page Title: $result');
```

For more details, check the `example` folder.