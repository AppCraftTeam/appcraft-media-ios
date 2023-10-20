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
    dependencies: [
        .package(
            name: "SnapKit",
            url: "https://github.com/SnapKit/SnapKit.git",
            from: "5.0.1"
        )
    ],
    targets: [
        .target(
            name: "ACMedia",
            dependencies: [
                .product(
                    name: "SnapKit",
                    package: "SnapKit"
                )
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "ACMediaTests",
            dependencies: ["ACMedia"],
            path: "Tests"
        ),
    ]
)
