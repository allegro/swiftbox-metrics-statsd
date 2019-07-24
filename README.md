
# SwiftBox Metrics StatsD

SwiftBox Metrics StatsD is a StatsD TCP/UDP client and and handler.
Handler is compatible with official swift-metrics API.

Coming soon: Replace SwiftBoxLogging implementation in favor of official swift-log.

[![Build Status](https://travis-ci.org/allegro/swiftbox-metrics-statsd.svg?branch=master)](https://travis-ci.org/allegro/swiftbox-metrics-statsd)
![Swift 4.1](https://img.shields.io/badge/swift-4.1-brightgreen.svg)
![Linux](https://img.shields.io/badge/linux-brightgreen.svg)
![MacOS](https://img.shields.io/badge/macos-brightgreen.svg)

## SwiftBoxMetricsStatsD
SatsD handler for official [swift-metrics](https://github.com/apple/swift-metrics) API.

Supported metric types:
- Counters
- Timers
- Gauges

### Usage

#### 1. Import
```swift
import Metrics
import SwiftBoxMetricsStatsD
```

#### 2. Bootstrap
Metrics must be bootstrap with Factory, that conforms to `MetricsFactory` protocol.
Default `StatsDMetricsFactory` accepts 2 parameters:
 - `baseMetricsPath`: path that is prepended to every recorded metric path
 - `handlerFactory`: Factory function that returns `MetricsHandler` implementation.
```swift
// StatsD Handler initialization
let statsdClient = UDPStatsDClient(
   config: UDPConnectionConfig(
       host: "127.0.0.1",
       port: 1234
   )
)
MetricsSystem.bootstrap(
    try StatsDMetricsFactory(
            baseMetricPath: "com.allegro"
    ) { path in
        StatsDMetricsHandler(
            path: path,
            client: statsdClient
        )
    }
)
```

#### 3. Usage
Detailed usage details may be found in official [swift-metrics](https://github.com/apple/swift-metrics) GitHub repository.

### Handlers

#### LoggerMetricsHandler
Default handler for metrics that prints gathered metrics to console.
```swift
MetricsSystem.bootstrap(
    try StatsDMetricsFactory(
            baseMetricPath: "com.allegro"
    ) { path in
        LoggerMetricsHandler(path: path)
    }
)
```

#### StatsDMetricsHandler
StatsD Metrics Handler responsible for sending gathered logs to statsD server. Supports TCP and UDP protocols.
Metrics are sent in separate thread, so operation is non-blocking for application.
```swift
StatsDMetricsHandler(
    path: "com.allegro.counter",
    client: UDPStatsDClient(
        config: UDPConnectionConfig(
            host: AppConfig.global.statsd.host!,
            port: AppConfig.global.statsd.port!
        )
    )
)
```

- `path` is a path that metric will be recorder at.
- `client` is a `TCPStatsDClient` or `UDPStatsDClient` instance.

#### Custom Handlers
To create custom handlers, conform to `MetricsHandler` or `BaseMetricsHandler` protocol.
