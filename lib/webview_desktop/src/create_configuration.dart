import 'dart:io';

class CreateConfiguration {
  final int windowWidth;
  final int windowHeight;

  /// the title of window
  final String title;

  /// Height of the optional Flutter-powered title bar.
  ///
  /// Defaults to zero so the WebView fills the native window unless callers
  /// explicitly opt into a custom title bar with [runWebViewTitleBarWidget].
  final int titleBarHeight;

  final int titleBarTopPadding;

  final String userDataFolderWindows;

  const CreateConfiguration({
    this.windowWidth = 1280,
    this.windowHeight = 720,
    this.title = "",
    this.titleBarHeight = 0,
    this.titleBarTopPadding = 0,
    this.userDataFolderWindows = 'webview_window_WebView2',
  });

  factory CreateConfiguration.platform() {
    return CreateConfiguration(titleBarTopPadding: Platform.isMacOS ? 24 : 0);
  }

  Map toMap() => {
    "windowWidth": windowWidth,
    "windowHeight": windowHeight,
    "title": title,
    "titleBarHeight": titleBarHeight,
    "titleBarTopPadding": titleBarTopPadding,
    "userDataFolderWindows": userDataFolderWindows,
  };
}
