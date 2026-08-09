# Support runbook

## Ownership and escalation

The GitHub CODEOWNERS entry is the first-line engineering owner. Public defects
go to the repository issue tracker. Security reports follow `SECURITY.md`.

## First-response checklist

1. Record package, Flutter, Dart, OS, architecture, and native runtime versions.
2. Confirm the failing URL scheme and whether the content is remote or bundled.
3. Capture the exception returned by `init` or the failed operation and the
   `WebViewLoadError` callback. Redact credentials and query parameters.
4. Reproduce with the repository example on the same platform.
5. Run `flutter doctor -v`, `flutter analyze`, and a debug example build.

## Common failures

| Symptom | Check | Action |
|---|---|---|
| Windows runtime unavailable | Evergreen WebView2 installation and architecture | Install/update the runtime; confirm x86/x64/ARM64 match |
| Linux configure failure | `pkg-config --modversion webkit2gtk-4.1` | Install the documented development package |
| `invalid_arguments` | Dart/native package version mismatch | Clean, resolve one package version, rebuild |
| `unsupported` | Capability table | Remove the call or gate it by platform |
| Navigation error | `onLoadError`, TLS, DNS, proxy | Fix the network/content problem; do not bypass TLS |
| Desktop asset misses CSS/images | Relative asset reference | Embed resources or use a local HTTP server |

## Logging and data handling

The package does not log full navigation URLs. Host applications own structured
logging, redaction, correlation IDs, metrics, and alerting. Never attach cookies,
authorization headers, or full tokenized URLs to public issues.

## Service indicators

Track initialization failures, navigation failures by platform/error code,
unexpected window closures, and unsupported-method errors in the host app.
