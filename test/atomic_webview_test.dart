import 'package:atomic_webview/atomic_webview.dart';
import 'package:atomic_webview/webview_desktop/src/webview_impl.dart';
import 'package:atomic_webview/webview_desktop/webview_desktop_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('webview_window');

  group('Atomic Webview Tests', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            log.add(methodCall);
            if (methodCall.method == 'create') {
              return 42;
            }
            return null;
          });
    });

    tearDown(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('WebviewWindow.create returns a Webview with correct ID', () async {
      final webview = await WebviewWindow.create();
      expect(webview, isA<WebviewImpl>());
      expect((webview as WebviewImpl).viewId, 42);
      expect(log, hasLength(1));
      expect(log.first.method, 'create');
    });

    test('WebViewController initialization on desktop', () async {
      // Note: This test assumes it's running on a desktop platform (Linux/macOS/Windows)
      // or at least that Platform.isDesktop is true in the test environment if using universal_io.
      final controller = WebViewController();

      // We can't easily mock BuildContext without a widget tester, so we test parts of it.
      expect(controller.is_init, isFalse);
    });

    testWidgets(
      'WebViewController.init marks desktop controller initialized before rebuilding',
      (tester) async {
        final controller = WebViewController();
        final setStateObservations = <bool>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final context = tester.element(find.byType(SizedBox));

        await controller.init(
          context: context,
          setState: (fn) {
            fn();
            setStateObservations.add(controller.is_init);
          },
          uri: Uri.parse('https://example.com'),
        );

        if (controller.is_desktop) {
          expect(setStateObservations, <bool>[true]);
          expect(controller.is_init, isTrue);
          expect(
            log.map((call) => call.method),
            containsAllInOrder(['create', 'setBrightness', 'launch']),
          );
        }
      },
    );

    testWidgets(
      'desktop WebView placeholder is constrained to the Scaffold body',
      (tester) async {
        final controller = WebViewController()
          ..is_init = true
          ..is_desktop = true
          ..is_mobile = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Atomic Webview Test')),
              body: Stack(
                children: [
                  const Text('Home'),
                  WebView(controller: controller),
                ],
              ),
            ),
          ),
        );

        final scaffoldBox = tester.renderObject<RenderBox>(
          find.byType(Scaffold),
        );
        final appBarBox = tester.renderObject<RenderBox>(find.byType(AppBar));
        final webViewBox = tester.renderObject<RenderBox>(find.byType(WebView));
        final webViewTop = webViewBox.localToGlobal(Offset.zero).dy;

        expect(webViewTop, appBarBox.size.height);
        expect(webViewBox.size.width, scaffoldBox.size.width);
        expect(
          webViewBox.size.height,
          scaffoldBox.size.height - appBarBox.size.height,
        );
      },
    );

    test('WebViewControllerExtension Methods (Desktop Path)', () async {
      final controller = WebViewController();

      // Manually trigger initialization behavior for desktop if we are in a desktop environment
      if (controller.is_desktop) {
        // Mocking the creation
        final webview = await WebviewWindow.create();
        controller.webview_desktop_controller = webview;
        controller.is_init = true;

        // Test goBackSync
        controller.goBackSync();
        expect(log.any((m) => m.method == 'back'), isTrue);

        // Test reload
        await controller.reload();
        expect(log.any((m) => m.method == 'reload'), isTrue);

        // Test stop
        await controller.stop();
        expect(log.any((m) => m.method == 'stop'), isTrue);

        // Test evaluateJavaScript
        await controller.evaluateJavaScript('console.log("test")');
        expect(log.any((m) => m.method == 'evaluateJavaScript'), isTrue);
      }
    });

    test('Platform detection logic', () {
      final controller = WebViewController();
      // One of them must be true
      expect(controller.is_desktop || controller.is_mobile, isTrue);
      // They should be mutually exclusive
      expect(controller.is_desktop && controller.is_mobile, isFalse);
    });
  });
}
