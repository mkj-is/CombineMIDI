// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "CombineMIDI",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "CombineMIDI",
            targets: ["CombineMIDI"]),
    ],
    targets: [
        .target(
            name: "CombineMIDI",
            dependencies: []),
        .testTarget(
            name: "CombineMIDITests",
            dependencies: ["CombineMIDI"]),
    ]
)
