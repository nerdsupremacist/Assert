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

    func testArrayBuilder() {
        let results = test {
            for number in 0..<3 {
                Assert(number % 2, equals: 0, message: "Expected \(number) to be even")
            }
        }

        xcTest {
            Assert(results.failures.count, equals: 1, message: "Expected exactly 1 failure")
            Assert(results.failures[0].path.count, equals: 1, message: "Expected path to populated")
            Assert(results.failures[0].path[0], equals: "Index 1", message: "Expected path to include index of failed iteration")
        }
    }
}
