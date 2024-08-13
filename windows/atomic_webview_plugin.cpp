#include "include/atomic_webview/atomic_webview_plugin.h"

#include "message_channel_plugin.h"
#include "web_view_window_plugin.h"

void AtomicWebviewPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  WebviewWindowPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
  RegisterClientMessageChannelPlugin(registrar);
}
