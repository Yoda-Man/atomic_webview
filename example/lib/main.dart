import 'dart:async';

import 'package:atomic_webview/atomic_webview.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  if (runWebViewTitleBarWidget(args)) {
    return;
  }
  runApp(const AtomicWebViewExample());
}

class AtomicWebViewExample extends StatelessWidget {
  const AtomicWebViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: WebViewPage());
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController(
      onLoadError: (error) {
        if (mounted) {
          setState(() => _error = error.description);
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    try {
      await _controller.init(
        context: context,
        setState: setState,
        uri: Uri.parse('https://flutter.dev'),
      );
    } on Object catch (error) {
      if (mounted) {
        setState(() => _error = error.toString());
      }
    }
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atomic Webview'),
        actions: [
          IconButton(
            tooltip: 'Back',
            onPressed: _controller.is_init ? _controller.goBack : null,
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            tooltip: 'Forward',
            onPressed: _controller.is_init ? _controller.goForward : null,
            icon: const Icon(Icons.arrow_forward),
          ),
          IconButton(
            tooltip: 'Reload',
            onPressed: _controller.is_init ? _controller.reload : null,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Load bundled HTML',
            onPressed: _controller.is_init
                ? () => _controller.loadAsset('assets/example.html')
                : null,
            icon: const Icon(Icons.folder_open),
          ),
        ],
      ),
      body: _error == null
          ? WebView(controller: _controller)
          : Center(child: SelectableText(_error!)),
    );
  }
}
