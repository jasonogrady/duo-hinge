// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DuoHinge",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "DuoHinge", targets: ["DuoHinge"])],
    targets: [
        .target(name: "DuoHinge"),
        .testTarget(name: "DuoHingeTests", dependencies: ["DuoHinge"]),
    ]
)
