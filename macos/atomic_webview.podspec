#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint webview_window.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'atomic_webview'
  s.version          = '0.1.6'
  s.summary          = 'Native macOS support for the Atomic Webview Flutter plugin.'
  s.description      = <<-DESC
Creates and controls a native WKWebView window for Atomic Webview.
                       DESC
  s.homepage         = 'https://github.com/Yoda-Man/atomic_webview'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Yoda-Man' => 'https://github.com/Yoda-Man' }
  s.source           = { :path => '.' }
  s.source_files     = 'atomic_webview/Sources/atomic_webview/**/*.swift'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.15'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
