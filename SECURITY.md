# Security policy

## Supported versions

Security fixes are made only on the latest published minor release. Consumers
must upgrade to the latest patch before requesting security support.

## Report a vulnerability

Do not open a public issue for an exploitable vulnerability. Use GitHub's
private vulnerability reporting for `Yoda-Man/atomic_webview`. Include affected
platforms and versions, a minimal reproduction, impact, and suggested mitigation.

Operational defects that do not expose confidentiality, integrity, or
availability can be filed through the public GitHub issue tracker.

## Security boundaries

Atomic Webview renders active web content. URLs, page scripts, navigation
callbacks, and JavaScript messages are untrusted unless the host application
establishes otherwise. The package does not provide authentication, content
sanitization, certificate bypasses, or a remote-content allowlist.
