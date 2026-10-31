// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LiquidGlassSlideToPay",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "LiquidGlassSlideToPay", targets: ["LiquidGlassSlideToPay"])
    ],
    targets: [
        .target(
            name: "LiquidGlassSlideToPay",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
