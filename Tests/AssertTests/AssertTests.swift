import XCTest
@testable import Assert

final class AssertTests: XCTestCase {
    func testExample() {
        let results = test {
            Assert(1, equals: 1, message: "1 equals 1")
            Assert(1, equals: 2, message: "1 equals 2")
            Assert(2, equals: 2, message: "2 equals 1")
            Assert(2, equals: 3, message: "2 equals 3")
        }

        xcTest {
            Assert(results.failures.count, equals: 2, message: "Expceted exactly 2 failures")
            let first = results.failures[0]
            let second = results.failures[1]

            Assert(first.message, equals: "1 equals 2")
            Assert(second.message, equals: "2 equals 3")
        }
    }
}
