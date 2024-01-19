// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ACMedia",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ACMedia",
            targets: ["ACMedia"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/DPLibs/DPUIKit.git",
            from: "5.0.0"
        )
    ],
    targets: [
        .target(
            name: "ACMedia",
            dependencies: [
                "DPUIKit"
            ],
            path: "Sources"
        )
    ]
)
