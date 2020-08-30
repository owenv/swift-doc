// swift-tools-version:5.3

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
    .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "0.3.0"))
  ],
  targets: [
    .target(
      name: "SwiftDoc",
      dependencies: [.product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core")]),
    .testTarget(
      name: "SwiftDocTests",
      dependencies: ["SwiftDoc"],
      resources: [.process("Inputs")]),
    .target(
      name: "swift-doc",
      dependencies: ["SwiftDoc",
                     .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core"),
                     .product(name: "ArgumentParser", package: "swift-argument-parser")])
  ]
)
