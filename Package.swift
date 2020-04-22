// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MIDIPublisher",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "MIDIPublisher",
            targets: ["MIDIPublisher"]),
    ],
    targets: [
        .target(
            name: "MIDIPublisher",
            dependencies: []),
        .testTarget(
            name: "MIDIPublisherTests",
            dependencies: ["MIDIPublisher"]),
    ]
)
