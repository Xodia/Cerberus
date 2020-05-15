// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cerberus",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Cerberus",
            targets: ["Cerberus"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/stencilproject/Stencil", .branch("master")),
        .package(url: "https://github.com/Xodia/CerberusCore", .branch("master")),
        .package(url: "https://github.com/ianpartridge/swift-log-syslog.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Cerberus",
            dependencies: ["Files", "Stencil", "CerberusCore", "LoggingSyslog"]),
        .testTarget(
            name: "CerberusTests",
            dependencies: ["Cerberus", "Files", "Stencil", "CerberusCore", "LoggingSyslog"]),
    ]
)
