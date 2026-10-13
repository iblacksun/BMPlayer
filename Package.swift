// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "BMPlayer",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "BMPlayer", targets: ["BMPlayer"])
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.6.0")),
        .package(url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", .upToNextMinor(from: "4.8.0")),
    ],
    targets: [
        // 对应 podspec 的 Full subspec，不包含 CacheSupport
        .target(name: "BMPlayer",
                dependencies: ["SnapKit", "NVActivityIndicatorView"],
                path: "Source",
                exclude: ["CacheSupport", "Info.plist", "BMPlayer.h"],
                resources: [
                    .process("Pod_Asset_BMPlayer.xcassets")
                ]),
    ]
)
