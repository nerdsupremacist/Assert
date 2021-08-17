
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
        for failure in failures {
            if let message = failure.message {
                XCTFail(message, file: failure.file, line: failure.line)
            } else {
                XCTFail(file: failure.file, line: failure.line)
            }
        }
    }

}

#endif
