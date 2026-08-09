// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "atomic_webview",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "atomic-webview", targets: ["atomic_webview"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "atomic_webview",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
