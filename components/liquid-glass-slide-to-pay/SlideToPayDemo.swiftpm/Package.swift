// swift-tools-version: 5.9
import PackageDescription
import AppleProductTypes

// An app playground that wraps the LiquidGlassSlideToPay package in a runnable iOS app.
// Open this folder in Xcode (or Swift Playgrounds) and press Run, or build it with
// xcodebuild and install the .app into a simulator. See ../README.md.
let package = Package(
    name: "SlideToPayDemo",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "SlideToPayDemo",
            targets: ["AppModule"],
            bundleIdentifier: "com.samsclub.prototypes.SlideToPayDemo",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .cart),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .phone,
                .pad
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    dependencies: [
        .package(path: "../LiquidGlassSlideToPay")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "LiquidGlassSlideToPay", package: "LiquidGlassSlideToPay")
            ],
            path: "."
        )
    ]
)
