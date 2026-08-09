# Dependency inventory

## Dart and Flutter

Direct package versions and constraints are recorded in `pubspec.yaml` and
`pubspec.lock`. Release preparation includes outdated and OSV vulnerability
checks. License notices from resolved Flutter packages are included by the
Flutter build system in application artifacts.

## Microsoft WebView2 SDK

- Package: `Microsoft.Web.WebView2`
- Version: `1.0.4078.44`
- Source: official Microsoft NuGet package
- NuGet SHA-256: `dc4d1d9168df26b830398303e50210b6e1729f6ce5a7ac69d2c766852f489962`
- Loader architectures: x86, x64, ARM64
- License and notice: `windows/webview2/`

Loader SHA-256 values:

| Architecture | SHA-256 |
|---|---|
| x86 | `5388b73b5ca00f1faf2a569cd923fdff00e316a254ef6df9fba240e3839a2c45` |
| x64 | `239a9d6614a6cfade62b47cdb0be36e3069eedc438c3e0647a9e7b7c84ef6ea0` |
| ARM64 | `eef3eba85d4c28eebddf966f016b1b43df1ee584573210c5a6eb9483387467c4` |

Update all headers, loaders, license files, version references, and checksums from
one NuGet archive in the same commit.

## Windows Implementation Library and strconv

The vendored WIL files retain `windows/wil/LICENSE` and
`windows/wil/ThirdPartyNotices.txt`. `windows/strconv.h` retains its embedded MIT
notice. Their provenance must be reviewed when either source is updated.
