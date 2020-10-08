// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "UberRides",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "UberCore", targets: ["UberCore"]),
        .library(name: "UberRides", targets: ["UberRides"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "UberCore", dependencies: [], path: "source/UberCore"),
        .target(name: "UberRides", dependencies: ["UberCore"], path: "source/UberRides"),
    ]
)
