# Architecture

## Overview

`WebViewController` is the public lifecycle and navigation API. Android, iOS,
and Web delegate to `webview_flutter`. Linux, macOS, and Windows use the
`webview_window` method channel to create a separate native window.

Desktop events travel back through the same channel. A secondary
`webview_message/client_channel` connects the optional Flutter title-bar engine
to the primary engine.

## Lifecycle

1. The application constructs a controller with its URL policy and callbacks.
2. `init` validates the initial URL and awaits native controller creation.
3. Desktop implementations create a native window, attach event handlers, and
   load the initial URL. Mobile/Web create the endorsed Flutter controller.
4. Navigation errors are returned to `onLoadError`; command failures complete
   their `Future` with an exception.
5. `dispose` closes a desktop window and removes extracted asset files.

## Platform channel contract

Command arguments are maps with a `viewId` integer unless the command creates or
clears all views. Native handlers must validate arguments and complete every
method result exactly once. Unknown and unsupported methods return structured
Flutter errors; they must never be silently ignored.

The protocol is integration-tested through the example build matrix. Any new
command must be added to all platform handlers or documented as unsupported.
