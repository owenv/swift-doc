// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftDoc",
    products: [
        .library(
            name: "SwiftDoc",
            targets: ["SwiftDoc"]),
        .executable(
            name: "swift-doc",
            targets: ["swift-doc"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "SwiftDoc",
            dependencies: ["SwiftToolsSupport-auto"]),
        .testTarget(
            name: "SwiftDocTests",
            dependencies: ["SwiftDoc"]),
        .target(
            name: "swift-doc",
            dependencies: ["SwiftDoc", "SwiftToolsSupport-auto"])
    ]
)
