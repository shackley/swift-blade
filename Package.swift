// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-blade",
    platforms: [
        .macOS(.v13),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(name: "Blade", targets: ["Blade"]),
        .library(name: "BladeExample", targets: ["BladeExample"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "Blade",
            dependencies: ["BladePlugin"]
        ),
        .testTarget(
            name: "BladeTests",
            dependencies: ["Blade"]
        ),
        .macro(
            name: "BladePlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .testTarget(
            name: "BladePluginTests",
            dependencies: [
                "BladePlugin",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "BladeValidator",
            dependencies: [
                .product(name: "SwiftParser", package: "swift-syntax"),
            ]
        ),
        .executableTarget(
            name: "BladeValidatorCommand",
            dependencies: [
                "BladeValidator",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .plugin(
            name: "BladeValidatorPlugin",
            capability: .buildTool(),
            dependencies: ["BladeValidatorCommand"]
        ),
        .target(
            name: "BladeExample",
            dependencies: ["Blade"],
            plugins: [
                "BladeValidatorPlugin"
            ]
        ),
    ]
)
