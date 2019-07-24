import Foundation

import Metrics

public struct InvalidConfigurationError: Error {
    let message: String
}

public class StatsDMetricsFactory: MetricsFactory {
    let handlerFactory: MetricsHandlerFactory
    let baseMetricPath: String
    static let basePathRegex = "^[a-z]+(?:\\.[a-z]+)*$"
    static let basePathTest = try! NSRegularExpression(pattern: basePathRegex, options: .caseInsensitive)

    public init(
        baseMetricPath: String,
        handlerFactory: @escaping MetricsHandlerFactory
    ) throws {
        guard StatsDMetricsFactory.validateBasePath(baseMetricPath) else {
            throw InvalidConfigurationError(message: "Invalid base path \(baseMetricPath), base path should consist only of small letters and dots, sample: example.com.test")
        }
        self.baseMetricPath = baseMetricPath
        self.handlerFactory = handlerFactory
    }

    internal static func validateBasePath(_ path: String) -> Bool {
        return basePathTest.matches(in: path, range: NSMakeRange(0, path.utf8.count)).count > 0
    }

    internal func getPath(_ label: String) -> String {
        return "\(baseMetricPath).\(label)"
    }

    public func makeCounter(label: String, dimensions: [(String, String)]) -> CounterHandler {
        return self.handlerFactory(getPath(label))
    }
    public func makeRecorder(label: String, dimensions: [(String, String)], aggregate: Bool) -> RecorderHandler {
        return self.handlerFactory(getPath(label))
    }
    public func makeTimer(label: String, dimensions: [(String, String)]) -> TimerHandler {
        return self.handlerFactory(getPath(label))
    }

    public func destroyCounter(_: CounterHandler) {}
    public func destroyRecorder(_: RecorderHandler) {}
    public func destroyTimer(_: TimerHandler) {}
}
