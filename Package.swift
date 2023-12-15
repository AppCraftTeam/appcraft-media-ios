// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ACMedia",
    platforms: [
        .iOS(.v12)
    ],
    defaultLocalization: "en",
    products: [
        .library(
            name: "ACMedia",
            targets: ["ACMedia"]
        )
    ],
    dependencies: [
        .package(
            name: "DPUIKit",
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
        ),
        .testTarget(
            name: "ACMediaTests",
            dependencies: ["ACMedia"],
            path: "Tests"
        )
    ]
)
