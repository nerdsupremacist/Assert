
import Foundation

public struct TestResults {
    public let successful: [Success]
    public let failures: [Failure]
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
