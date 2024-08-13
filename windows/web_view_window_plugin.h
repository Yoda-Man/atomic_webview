#ifndef atomic_webview_WINDOWS_WEB_VIEW_PLUGIN_H_
#define atomic_webview_WINDOWS_WEB_VIEW_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include "strconv.h"
#include "webview_window.h"

#include <memory>

class WebviewWindowPlugin: public flutter::Plugin {
 public:

  using MethodChannelPtr = std::shared_ptr<flutter::MethodChannel<flutter::EncodableValue>>;

  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  explicit WebviewWindowPlugin(MethodChannelPtr method_channel);

  ~WebviewWindowPlugin() override;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  MethodChannelPtr method_channel_;

  std::map<int64_t, std::unique_ptr<WebviewWindow>> windows_;

};

#endif //atomic_webview_WINDOWS_WEB_VIEW_PLUGIN_H_
