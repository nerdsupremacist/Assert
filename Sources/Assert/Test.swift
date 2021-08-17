
import Foundation

public protocol Test {
    associatedtype Body: Test

    @TestBuilder
    var body: Body { get }
}

public func test<Content: Test>(@TestBuilder build: () -> Content) -> TestResults {
    let content = build()
    let context = TestContext()
    context.use(test: content)
    return TestResults(successful: context.successful, failures: context.failures)
}

#if canImport(XCTest)
import XCTest

public func xcTest<Content: Test>(@TestBuilder build: () -> Content) {
    let results = test(build: build)
    results.xcTest()
}
#endif
