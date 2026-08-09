# Atomic Webview

Atomic Webview provides one Flutter controller for Android, iOS, Linux, macOS,
Web, and Windows. Mobile and Web use the maintained `webview_flutter`
implementations. Desktop opens a separate native WebView window.

## Platform support

| Capability | Android | iOS | Web | Linux | macOS | Windows |
|---|---:|---:|---:|---:|---:|---:|
| HTTP/HTTPS navigation | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Back, forward, reload, stop | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| JavaScript evaluation | ✅ | ✅ | Limited by browser | ✅ | ✅ | ✅ |
| Bundled HTML asset | ✅ | ✅ | Not supported | ✅ | ✅ | ✅ |
| Navigation/error callbacks | ✅ | ✅ | Platform-dependent | ✅ | ✅ | ✅ |
| Document-start scripts | Platform API | Platform API | ❌ | ✅ | ✅ | ✅ |
| JavaScript message handlers | Platform API | Platform API | Platform API | ❌ | ✅ | ❌ |
| Web message post/receive | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| DevTools window | ❌ | ❌ | Browser-owned | ❌ | ❌ | ✅ |

Windows builds bundle the Microsoft WebView2 loader for x86, x64, and ARM64.
The Evergreen WebView2 Runtime must be installed on the target device.

## Requirements

- Dart 3.12.2 or newer in the 3.x line.
- Flutter 3.44.4 or newer.
- Android API 19 or newer.
- A current WebView2 Evergreen Runtime on Windows.
- `libwebkit2gtk-4.1-dev` on current Ubuntu/Debian releases, or
  `libwebkit2gtk-4.0-dev` on older supported distributions.

```bash
sudo apt install libwebkit2gtk-4.1-dev
```

## Installation

```yaml
dependencies:
  atomic_webview: ^0.1.6
```

```bash
flutter pub get
```

## Quick start

```dart
import 'dart:async';

import 'package:atomic_webview/atomic_webview.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  if (runWebViewTitleBarWidget(args)) return;
  runApp(const MaterialApp(home: WebViewPage()));
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  String? error;

  @override
  void initState() {
    super.initState();
    controller = WebViewController(
      onLoadError: (event) {
        if (mounted) setState(() => error = event.description);
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await controller.init(
          context: context,
          setState: setState,
          uri: Uri.parse('https://flutter.dev'),
        );
      } on Object catch (exception) {
        if (mounted) setState(() => error = exception.toString());
      }
    });
  }

  @override
  void dispose() {
    unawaited(controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (error case final message?) {
      return Scaffold(body: Center(child: SelectableText(message)));
    }
    return Scaffold(body: WebView(controller: controller));
  }
}
```

On Linux, macOS, and Windows the widget displays a status placeholder while the
page runs in a separate native window.

## Configuration and errors

The controller accepts HTTP and HTTPS by default. Restrict it further, or add a
scheme deliberately, through `allowedSchemes`:

```dart
final controller = WebViewController(
  allowedSchemes: const {'https'},
  onNavigation: (uri) => auditNavigation(uri),
  onLoadError: (error) => reportFailure(error.description),
);
```

Invalid schemes throw `ArgumentError`. Operations before `init` completes throw
`StateError`. Missing native runtimes and native channel failures are surfaced
through the returned `Future`; do not discard it. Call `dispose` when finished.

## Navigation and assets

```dart
await controller.go(uri: Uri.parse('https://dart.dev'));
await controller.goBack();
await controller.goForward();
await controller.reload();
await controller.stop();
final title = await controller.evaluateJavaScript('document.title');
```

`loadAsset` loads a Flutter asset. On desktop it extracts the individual asset
to an isolated temporary directory and removes it during `dispose`.

```dart
await controller.loadAsset('assets/index.html');
```

Desktop extraction does not copy sibling assets referenced by relative paths.
Bundle standalone HTML, embed its resources, or serve a multi-file site from a
local HTTP server.

## Advanced desktop API

The controller exposes `webview_desktop_controller` after successful desktop
initialization. Check the support table before calling platform-specific APIs.
Unsupported calls return a `PlatformException` with code `unsupported`.

```dart
import 'dart:io' show Platform;

if (controller.is_desktop && controller.is_init) {
  final desktop = controller.webview_desktop_controller;
  await desktop.addScriptToExecuteOnDocumentCreated('window.atomic = true;');
  desktop.setOnHistoryChangedCallback((canBack, canForward) {});
  await desktop.setApplicationNameForUserAgent('MyApp/1.0');

  if (Platform.isWindows) {
    await desktop.openDevToolsWindow();
    await desktop.postWebMessageAsString('hello');
  }
}
```

## Security

- Only load content you trust. JavaScript is enabled for application content.
- Keep the default scheme restriction unless another scheme is required.
- Do not place credentials or bearer tokens in URLs.
- Treat JavaScript messages as untrusted input and validate them in the host app.
- Enabling Android cleartext traffic weakens transport security and is not a
  package requirement. Prefer HTTPS.

See [SECURITY.md](SECURITY.md) for reporting and supported-version policy.

## Development and support

The complete example is in [`example/`](example/). Before submitting a change:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test --coverage
dart run tool/check_coverage.dart coverage/lcov.info 30
dart pub publish --dry-run
```

- [Architecture](doc/ARCHITECTURE.md)
- [Support runbook](doc/SUPPORT.md)
- [Release and rollback process](doc/RELEASE.md)
- [Dependency inventory](doc/DEPENDENCIES.md)
- [Contributing](CONTRIBUTING.md)

## License

Atomic Webview is MIT licensed. Vendored third-party notices are listed in the
[dependency inventory](doc/DEPENDENCIES.md).
