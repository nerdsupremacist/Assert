// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Assert",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(name: "Assert",
                 targets: ["Assert"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nerdsupremacist/AssociatedTypeRequirementsKit.git",
                 from: "0.3.2")
    ],
    targets: [
        .target(name: "Assert",
                dependencies: ["AssociatedTypeRequirementsKit"],
                exclude: ["TestBuilder.swift.gyb"]),
        .testTarget(name: "AssertTests",
                    dependencies: ["Assert"]),
    ]
)
