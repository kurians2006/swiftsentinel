// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SampleIOSApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "SampleIOSApp",
            targets: ["SampleIOSApp"]
        ),
    ],
    targets: [
        .target(
            name: "SampleIOSApp",
            dependencies: []
        ),
        .testTarget(
            name: "SampleIOSAppTests",
            dependencies: ["SampleIOSApp"]
        ),
    ]
)
