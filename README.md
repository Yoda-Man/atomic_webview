<p align="center">
  <img src="doc/assets/atomic-webview-logo.png" width="190" alt="Atomic Webview logo">
</p>

<h1 align="center">Atomic Webview</h1>

<p align="center">
  <strong>One controller. Six platforms. Native where it matters.</strong><br>
  A unified Flutter WebView for Android, iOS, Web, Linux, macOS, and Windows.
</p>

<p align="center">
  <a href="https://pub.dev/packages/atomic_webview"><img src="https://img.shields.io/pub/v/atomic_webview.svg?logo=dart&logoColor=white" alt="pub.dev version"></a>
  <a href="https://github.com/Yoda-Man/atomic_webview/actions/workflows/ci.yml"><img src="https://github.com/Yoda-Man/atomic_webview/actions/workflows/ci.yml/badge.svg?branch=dev" alt="CI status"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-7c3aed.svg" alt="MIT license"></a>
  <img src="https://img.shields.io/badge/Flutter-3.47.8%2B-02569B?logo=flutter&logoColor=white" alt="Flutter 3.47.8 or newer">
</p>

---

Atomic Webview gives Flutter apps a consistent navigation and lifecycle API
without pretending every platform works the same way. Android, iOS, and Web use
the maintained `webview_flutter` implementations. Linux, macOS, and Windows use
native desktop WebViews in a separate window.

## Highlights

- **One controller** for navigation, JavaScript, assets, errors, and lifecycle.
- **Six supported platforms** with explicit capability differences.
- **Native desktop engines**: WebKitGTK, WKWebView, and Microsoft WebView2.
- **Safe defaults**: HTTP/HTTPS scheme validation and surfaced async failures.
- **Local content support** for bundled, standalone HTML files.
- **Optional desktop title bar** built with Flutter.
- **Release-grade checks** across Web, Android, Linux, macOS, and Windows.

## Platform support

| Capability | Android | iOS | Web | Linux | macOS | Windows |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| HTTP/HTTPS navigation | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Back, forward, reload, stop | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| JavaScript evaluation | ✅ | ✅ | Browser-limited | ✅ | ✅ | ✅ |
| Bundled HTML asset | ✅ | ✅ | — | ✅ | ✅ | ✅ |
| Navigation and error callbacks | ✅ | ✅ | Platform-dependent | ✅ | ✅ | ✅ |
| Document-start scripts | Platform API | Platform API | — | ✅ | ✅ | ✅ |
| JavaScript message handlers | Platform API | Platform API | Platform API | — | ✅ | — |
| Web message post/receive | — | — | — | — | — | ✅ |
| DevTools window | — | — | Browser-owned | — | — | ✅ |

> [!NOTE]
> Desktop WebViews run in their own native window. The Flutter widget displays a
> status placeholder while that window is open.

## Install

```yaml
dependencies:
  atomic_webview: ^0.2.0
```

```bash
flutter pub get
```

Requires Dart 3.13.7+ and Flutter 3.47.8+.

### Desktop prerequisites

| Platform | Requirement |
|---|---|
| Linux | `libwebkit2gtk-4.1-dev`, or `libwebkit2gtk-4.0-dev` on older distributions |
| macOS | macOS 12.0+ |
| Windows | Microsoft Edge WebView2 Evergreen Runtime |

```bash
# Ubuntu / Debian
sudo apt install libwebkit2gtk-4.1-dev
```

Windows builds include the WebView2 loader for x86, x64, and ARM64. The
Evergreen Runtime itself must be installed on the target device.

## Quick start

```dart
import 'dart:async';

import 'package:atomic_webview/atomic_webview.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  if (runWebViewTitleBarWidget(args)) return;
  runApp(const MaterialApp(home: BrowserPage()));
}

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) => initialize());
  }

  Future<void> initialize() async {
    try {
      await controller.init(
        context: context,
        setState: setState,
        uri: Uri.parse('https://flutter.dev'),
      );
    } on Object catch (exception) {
      if (mounted) setState(() => error = exception.toString());
    }
  }

  @override
  void dispose() {
    unawaited(controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atomic Webview'),
        actions: [
          IconButton(
            tooltip: 'Reload',
            onPressed: controller.is_init ? controller.reload : null,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: error == null
          ? WebView(controller: controller)
          : Center(child: SelectableText(error!)),
    );
  }
}
```

## Navigate and run JavaScript

Every asynchronous command reports native failures through its returned
`Future`. Await commands unless you deliberately route failures elsewhere.

```dart
await controller.go(uri: Uri.parse('https://dart.dev'));
await controller.goBack();
await controller.goForward();
await controller.reload();
await controller.stop();

final title = await controller.evaluateJavaScript('document.title');
```

Operations before `init` completes throw `StateError`.

## Control navigation

HTTP and HTTPS are allowed by default. Restrict schemes and observe navigation
from the controller:

```dart
final controller = WebViewController(
  allowedSchemes: const {'https'},
  onNavigation: (uri) => auditNavigation(uri),
  onLoadError: (event) => reportFailure(event.description),
);
```

Invalid initial or programmatic schemes throw `ArgumentError`. Treat callback
URLs and page messages as untrusted input.

## Load bundled HTML

Declare the file in your application's `pubspec.yaml`, then load it after
initialization:

```yaml
flutter:
  assets:
    - assets/help.html
```

```dart
await controller.loadAsset('assets/help.html');
```

Desktop extraction copies one file. For HTML that references sibling CSS,
images, or scripts, embed the resources or serve the directory from a local
HTTP server.

## Use desktop-only features

The advanced controller is available after desktop initialization. Gate
platform-specific calls explicitly:

```dart
import 'dart:io' show Platform;

if (controller.is_desktop && controller.is_init) {
  final desktop = controller.webview_desktop_controller;

  await desktop.addScriptToExecuteOnDocumentCreated(
    'window.atomicWebview = true;',
  );
  desktop.setOnHistoryChangedCallback((canBack, canForward) {});
  await desktop.setApplicationNameForUserAgent('MyApp/1.0');

  if (Platform.isWindows) {
    await desktop.openDevToolsWindow();
    await desktop.postWebMessageAsString('hello');
  }
}
```

Unsupported desktop calls complete with a `PlatformException` whose code is
`unsupported`.

## Add a Flutter desktop title bar

Call `runWebViewTitleBarWidget(args)` before the main app starts, as shown in
the quick start. Opt into title-bar space with `CreateConfiguration` when using
the advanced desktop API:

```dart
final webview = await WebviewWindow.create(
  configuration: const CreateConfiguration(titleBarHeight: 40),
);
```

The default height is zero, so the native WebView fills the window.

## Security

- Load only content your application trusts.
- Keep the default scheme restriction unless another scheme is required.
- Restrict remote hosts in the consuming application; scheme checks are not a
  domain allowlist.
- Never place credentials or bearer tokens in URLs.
- Validate JavaScript messages before acting on them.
- Prefer HTTPS; Android cleartext traffic is not required by this package.

See [SECURITY.md](SECURITY.md) for the supported-version and private-reporting
policy.

## Develop

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test --coverage
dart run tool/check_coverage.dart coverage/lcov.info 40
dart pub publish --dry-run
```

The complete runnable app is in [`example/`](example/).

## Project guides

- [Architecture](doc/ARCHITECTURE.md)
- [Support runbook](doc/SUPPORT.md)
- [Release and rollback](doc/RELEASE.md)
- [Dependency inventory](doc/DEPENDENCIES.md)
- [Contributing](CONTRIBUTING.md)

## License

Atomic Webview is available under the [MIT License](LICENSE). Vendored
third-party notices are documented in the [dependency inventory](doc/DEPENDENCIES.md).
