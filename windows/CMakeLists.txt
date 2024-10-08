cmake_minimum_required(VERSION 3.14)
set(PROJECT_NAME "atomic_webview")
project(${PROJECT_NAME} LANGUAGES CXX)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "atomic_webview_plugin")

add_library(${PLUGIN_NAME} SHARED
        "atomic_webview_plugin.cpp"
        "webview_window.h"
        "webview_window.cc"
        "strconv.h"
        "utils.h"
        "utils.cc"
        "flutter_view.h"
        "flutter_view.cc"
        "web_view.h"
        "web_view.cc"
        "message_channel_plugin.h"
        "message_channel_plugin.cc"
        "web_view_window_plugin.h"
        "web_view_window_plugin.cc"
        )

apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
        CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
        "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin flutter_wrapper_app)

add_library(Webview2 SHARED IMPORTED GLOBAL)
SET_PROPERTY(TARGET Webview2 PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/libs/x64/Webview2Loader.dll)
SET_PROPERTY(TARGET Webview2 PROPERTY IMPORTED_IMPLIB ${CMAKE_CURRENT_SOURCE_DIR}/libs/x64/Webview2Loader.dll.lib)

target_link_libraries(${PLUGIN_NAME} PRIVATE Webview2 uxtheme)

# List of absolute paths to libraries that should be bundled with the plugin
set(atomic_webview_bundled_libraries
        "$<TARGET_FILE:Webview2>"
        PARENT_SCOPE
        )
