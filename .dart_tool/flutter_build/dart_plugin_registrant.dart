//
// Generated file. Do not edit.
// This file is generated from template in file `flutter_tools/lib/src/flutter_plugins.dart`.
//

// @dart = 3.10

import 'dart:io'; // flutter_ignore: dart_io_import.
import 'package:webview_flutter_android/webview_flutter_android.dart' as webview_flutter_android;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart' as webview_flutter_wkwebview;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart' as webview_flutter_wkwebview;

@pragma('vm:entry-point')
class _PluginRegistrant {

  @pragma('vm:entry-point')
  static void register() {
    if (Platform.isAndroid) {
      try {
        webview_flutter_android.AndroidWebViewPlatform.registerWith();
      } catch (err) {
        print(
          '`webview_flutter_android` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

    } else if (Platform.isIOS) {
      try {
        webview_flutter_wkwebview.WebKitWebViewPlatform.registerWith();
      } catch (err) {
        print(
          '`webview_flutter_wkwebview` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

    } else if (Platform.isLinux) {
    } else if (Platform.isMacOS) {
      try {
        webview_flutter_wkwebview.WebKitWebViewPlatform.registerWith();
      } catch (err) {
        print(
          '`webview_flutter_wkwebview` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

    } else if (Platform.isWindows) {
    }
  }
}
