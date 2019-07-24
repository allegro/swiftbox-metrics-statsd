#if os(Linux)

import XCTest
@testable import SwiftBoxMetricsStatsDTests


XCTMain([
    testCase(StatsDHandlerTests.allTests),
    testCase(MetricTypesTests.allTests),
    testCase(TCPStatsDClientTests.allTests),
    testCase(UDPStatsDClientTests.allTests),
])

#endif
