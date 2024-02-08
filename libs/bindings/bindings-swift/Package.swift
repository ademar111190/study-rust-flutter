import PackageDescription

let package = Package(
    name: "bindings-swift",
    platforms: [
        .macOS(.v12),
        .iOS(.v11),
    ],
    products: [
        .library(name: "Study", targets: ["studyFFI", "Study"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(name: "studyFFI", path: "./studyFFI.xcframework"),
        .target(name: "Study", dependencies: ["studyFFI"]),
    ]
)
