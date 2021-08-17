
import Foundation

public struct TestResults {
    public let successful: [Success]
    public let failures: [Failure]
}

extension TestResults {

    public static let empty = TestResults(successful: [], failures: [])

    public static func + (lhs: TestResults, rhs: TestResults) -> TestResults {
        return TestResults(successful: lhs.successful + rhs.successful,
                           failures: lhs.failures + rhs.failures)
    }

}

#if canImport(XCTest)
import XCTest

extension TestResults {

    public func xcTest() {
        for success in successful {
            let message = (success.path + [success.message]).compactMap { $0 }.joined(separator: " | ")
            if !message.isEmpty {
                XCTAssert(true, message, file: success.file, line: success.line)
            } else {
                XCTAssert(true, file: success.file, line: success.line)
            }
        }
        for failure in failures {
            let message = (failure.path + [failure.message]).compactMap { $0 }.joined(separator: " | ")
            if !message.isEmpty {
                XCTFail(message, file: failure.file, line: failure.line)
            } else {
                XCTFail(file: failure.file, line: failure.line)
            }
        }
    }

}

#endif
