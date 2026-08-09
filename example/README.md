# Atomic Webview example

This app exercises initialization, navigation, error reporting, bundled HTML
loading, lifecycle disposal, and the optional desktop title bar.

Run it on any configured Flutter target:

```bash
flutter pub get
flutter run -d macos
```

Desktop targets open the WebView in a separate native window. Web and mobile
targets render it in the Flutter widget tree.
