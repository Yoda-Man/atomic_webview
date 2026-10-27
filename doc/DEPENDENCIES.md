# Dependency inventory

## Dart and Flutter

Direct package versions and constraints are recorded in `pubspec.yaml` and
`pubspec.lock`. Release preparation includes outdated and OSV vulnerability
checks. License notices from resolved Flutter packages are included by the
Flutter build system in application artifacts.

Dependabot checks Dart, Gradle, and GitHub Actions dependencies weekly. The OSV
workflow scans pull requests, every push to `main`, weekly, and again before a
tagged release is published.

## Microsoft WebView2 SDK

- Package: `Microsoft.Web.WebView2`
- Version: `1.0.4314.35`
- Source: official Microsoft NuGet package
- NuGet SHA-256: `90778deb1b77e36292828b4b5833c9255c27533f40e0ddd55891ae718944edc4`
- Loader architectures: x86, x64, ARM64
- License and notice: `windows/webview2/`

Loader SHA-256 values:

| Architecture | SHA-256 |
|---|---|
| x86 | `1d348d3c0a5cb0d985389b68a0fd9bf966c2aed65f5e44bbc0233739b7a57f9e` |
| x64 | `d3fce90bdeecb08596e377dea6a316354dd8949e32ff09b89d51be00c14e21b6` |
| ARM64 | `05429881d918fd64a3fe4955155c1af79e66d7b7d944034467874f420bc2265a` |

Update all headers, loaders, license files, version references, and checksums from
one NuGet archive in the same commit.

## Windows Implementation Library and strconv

The vendored WIL files retain `windows/wil/LICENSE` and
`windows/wil/ThirdPartyNotices.txt`. `windows/strconv.h` retains its embedded MIT
notice. Their provenance must be reviewed when either source is updated.
