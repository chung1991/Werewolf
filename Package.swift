// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Werewolf",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(name: "WerewolfCore", targets: ["WerewolfCore"]),
    ],
    targets: [
        .target(
            name: "WerewolfCore",
            path: "WerewolfCore/WerewolfCore",
            exclude: ["WerewolfCore.docc", "WerewolfCore.h"],
            swiftSettings: [.unsafeFlags(["-warn-concurrency"])]
        ),
        .testTarget(
            name: "WerewolfCoreTests",
            dependencies: ["WerewolfCore"],
            path: "WerewolfCore/WerewolfCoreTests",
            swiftSettings: [.unsafeFlags(["-warn-concurrency"])]
        )
    ]
)
