import XCTest
@testable import Assert

final class AssertTests: XCTestCase {
    func testExample() {
        let results = test {
            Assert(1, equals: 1, message: "1 equals 1")
            Assert(1, equals: 2)
            Assert(2, equals: 2, message: "2 equals 1")
            Assert(2, equals: 3, message: "2 equals 3")
        }

        xcTest {
            Assert(results.failures.count, equals: 2, message: "Expceted exactly 2 failures") {
                let first = results.failures[0]
                let second = results.failures[1]

                Assert(first.message, equals: "Expected 1 to be equal to 2")
                Assert(second.message, equals: "2 equals 3")
            }
        }
    }

    func testArrayBuilder() {
        xcTest {
            ArrayBuilderTest()
        }
    }

    func testErrorThrowing() {
        xcTest {
            ErrorThrowingTest()
        }
    }
}

struct ArrayBuilderTest: Test {
    var body: some Test {
        let results = test {
            for number in 0..<3 {
                Assert(number % 2, equals: 0, message: "Expected \(number) to be even")
            }
        }

        Assert(isNotNil: results.failures.first, message: "Expected at least one failure") { failure in
            Assert(failure.message, equals: "Expected 1 to be even")
        }
        Assert(results.failures.count, equals: 1, message: "Expected exactly 1 failure")
        Assert(results.failures[0].path.count, equals: 1, message: "Expected path to populated")
        Assert(results.failures[0].path[0], equals: "Index 1", message: "Expected path to include index of failed iteration")
    }
}

struct ErrorThrowingTest: Test {
    var body: some Test {
        Assert(throws: try throwsSomething()) { error in
            Assert(error, toBeOfType: SomeError.self) { error in
                Assert(error, equals: .something)
            }
        }
    }
}

enum SomeError: Error, Equatable {
    case something
}

func throwsSomething() throws {
    throw SomeError.something
}
