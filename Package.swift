// swift-tools-version:4.2

import PackageDescription

let package = Package(
        name: "SwiftBoxMetricsStatsD",

        products: [
            .library(name: "SwiftBoxMetricsStatsD", type: .static, targets: ["SwiftBoxMetricsStatsD"]),
        ],
        dependencies: [
            .package(url: "https://github.com/allegro/swiftbox-logging.git", from: "1.0.0"),
            .package(url: "https://github.com/apple/swift-metrics.git", from: "1.0.0"),
        ],

        targets: [
            .target(
                    name: "SwiftBoxMetricsStatsD",
                    dependencies: ["SwiftBoxLogging", "Metrics"]
            ),
            .testTarget(
                    name: "SwiftBoxMetricsStatsDTests",
                    dependencies: ["SwiftBoxMetricsStatsD"]
            ),
        ]
)
