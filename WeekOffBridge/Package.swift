// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WeekOffBridge",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "WeekOffBridge",
            swiftSettings: [.swiftLanguageMode(.v5)]
        )
    ]
)
