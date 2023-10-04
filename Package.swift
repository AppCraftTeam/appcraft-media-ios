// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ACMedia",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ACMedia",
            targets: ["ACMedia"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ACMedia",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "ACMediaTests",
            dependencies: ["ACMedia"],
            path: "Tests"
        ),
    ]
)
