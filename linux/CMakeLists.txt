cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "atomic_webview")
project(${PROJECT_NAME} LANGUAGES CXX)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "atomic_webview_plugin")

find_package(PkgConfig REQUIRED)
# Prefer the GTK4 variant (webkit2gtk-4.1) available from Ubuntu 22.04 onwards.
pkg_check_modules(WebKit IMPORTED_TARGET webkit2gtk-4.1)
if (WebKit_FOUND)
  # webkit2gtk-4.1 removed the old WebKitJavascriptResult accessor API
  # (webkit_javascript_result_get_js_value) even at versions < 2.40.
  # Signal this to the C++ source after the plugin target has been created.
  set(WEBKIT_IS_GTK4_VARIANT TRUE)
else ()
  pkg_check_modules(WebKit REQUIRED IMPORTED_TARGET webkit2gtk-4.0)  # for backward compatibility
endif ()

add_library(${PLUGIN_NAME} SHARED
        "atomic_webview_plugin.cc"
        webview_window.cc
        webview_window.h
        message_channel_plugin.h
        message_channel_plugin.cc
        )
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
        CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
if (WEBKIT_IS_GTK4_VARIANT)
  target_compile_definitions(${PLUGIN_NAME} PRIVATE WEBKIT_IS_GTK4_VARIANT)
endif ()
target_include_directories(${PLUGIN_NAME} INTERFACE
        "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::WebKit)

# List of absolute paths to libraries that should be bundled with the plugin
set(atomic_webview_bundled_libraries
        ""
        PARENT_SCOPE
        )
