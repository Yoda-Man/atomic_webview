import 'dart:async';
import 'dart:io';

import 'package:atomic_webview/atomic_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late HttpServer server;

  setUpAll(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) {
      request.response
        ..headers.contentType = ContentType.html
        ..write('''
<!doctype html>
<html><head><title>atomic-ready</title></head><body>ready</body></html>
''')
        ..close();
    });
  });

  tearDownAll(() => server.close(force: true));

  testWidgets('loads and evaluates JavaScript in a native WebView', (
    tester,
  ) async {
    final controller = WebViewController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(home: Builder(builder: (_) => const SizedBox.shrink())),
    );
    final context = tester.element(find.byType(SizedBox));
    final uri = Uri.parse('http://127.0.0.1:${server.port}/');

    final title = await tester.runAsync<String>(() async {
      await controller.init(context: context, setState: (_) {}, uri: uri);
      Object? lastError;
      for (var attempt = 0; attempt < 40; attempt++) {
        try {
          final value = await controller.evaluateJavaScript('document.title');
          if (value?.contains('atomic-ready') ?? false) {
            return value!;
          }
        } on Object catch (error) {
          // The native controller can reject JavaScript while navigation starts.
          lastError = error;
        }
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
      throw TimeoutException(
        'Native WebView did not finish loading $uri. Last error: $lastError',
      );
    });

    expect(title, contains('atomic-ready'));
  });
}
