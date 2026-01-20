import 'package:atomic_webview/webview_desktop/src/webview_impl.dart';
import 'package:atomic_webview/webview_desktop/webview_desktop_app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('webview_window');

  group('Atomic Webview Tests', () {
    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            if (methodCall.method == 'create') {
              return 42;
            }
            return null;
          });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('WebviewWindow.create returns a Webview with correct ID', () async {
      final webview = await WebviewWindow.create();
      expect(webview, isA<WebviewImpl>());
      expect((webview as WebviewImpl).viewId, 42);
    });
  });
}
