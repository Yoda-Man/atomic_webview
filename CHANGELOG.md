## 0.1.6
* **Critical fix**: Restored the WebKitGTK 4.1 CMake target-order correction that regressed in 0.1.5 and kept the Linux plugin compatible with Flutter's C++14 build settings.
* **Fix**: Completed macOS method-channel results and corrected JavaScript handler removal.
* **Fix**: Added URI policy validation, observable navigation errors, awaited initialization, lifecycle disposal, and reliable desktop asset extraction.
* **Fix**: Added deterministic unsupported-method errors for Windows-only desktop capabilities.
* **Security**: Removed hardcoded navigation/UI behavior, stopped logging full URLs, validated native channel arguments, and updated the versioned WebView2 SDK for x86, x64, and ARM64.
* **Test**: Added a cross-platform example, expanded unit coverage, and introduced Linux, macOS, Windows, Android, and Web CI builds.
* **Docs**: Added architecture, support, release/rollback, security, ownership, contribution, and dependency documentation.

## 0.1.5
* **Fix**: Ensured `WebViewController.init` marks controllers initialized before triggering rebuilds, so desktop WebView widgets rebuild with the correct state.
* **Test**: Added regression coverage for desktop initialization ordering and Scaffold body layout constraints.
* **Chore**: Raised SDK constraints to Flutter 3.44.4 / Dart 3.12.2 and updated direct dependencies to their latest resolvable versions.

## 0.1.4
* **Fix**: Corrected Linux CMake target setup for WebKitGTK 4.1 so the desktop plugin registers reliably and avoids `MissingPluginException` on `webview_window.create` (Issue #8).

## 0.1.3
* **Fix**: Removed the default blank desktop title-bar space so Linux WebViews fill the native window unless a custom title bar is explicitly configured (Issue #9).
* **Maintenance**: Updated the minimum Flutter SDK to 3.41.9 / Dart 3.11.5 and refreshed package dependencies.

## 0.1.2
* **Fix**: Resolved `MissingPluginException` on Windows by correcting a Dart field-shadowing bug in `WebViewController.init` that prevented the desktop controller from being assigned.
* **Fix**: Added null guard in `FlutterView::GetWindow()` on Windows to prevent a crash when the optional Flutter title-bar bundle is absent.
* **Fix**: Removed unnecessary `flutter_wrapper_app` headers from the public Windows plugin header to eliminate undeclared dependency issues.
* **Fix**: Resolved Linux build failure (`no matching function for call to 'webkit_javascript_result_get_js_value'`) on Ubuntu 22.04+ (webkit2gtk-4.1). This also resolves the `MissingPluginException` for `create` on Linux that was caused by the compilation failure (Issue #2).

## 0.1.1
* **Fix**: Resolved compilation errors on the Web platform by adding missing stubs to the web implementation.
* **Feature**: Added comprehensive unit tests for `WebViewController` and platform handling.
* **Docs**: Updated documentation and README with latest platform support details.

## 0.1.0
* **Feature**: Added full API parity for Desktop (Linux, macOS, Windows) in `WebViewController`.
* **Feature**: Added `loadAsset` method to simplify loading local Flutter assets.
* **Fix**: Implemented backward compatible Linux build fix for older WebKitGTK versions.
* **Refactor**: Improved `WebView` widget platform handling.

## 0.0.9
* fix linux build
## 0.0.8
* Update dependencies to latest versions
* Fix Windows support configuration
* Improve documentation and examples

## 0.0.7
* update dependencies add support for windows

## 0.0.6
* linux webkit2 version find compatibiltiy

## 0.0.5
* update dependencies

## 0.0.4
* update notes

## 0.0.3

* Add Notes For Ubuntu

## 0.0.2

* Add documentation

## 0.0.1

* First release
