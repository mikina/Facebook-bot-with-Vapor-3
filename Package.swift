// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Facebook-bot-with-Vapor-3",
    products: [
        .library(name: "Facebook-bot-with-Vapor-3", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

