// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ClaudePeak",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "ClaudePeak",
            path: "Sources"
        )
    ]
)
