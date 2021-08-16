
import Foundation

public func test<Content: Assertion>(@AssertionBuilder build: () -> Content) -> TestResults {
    let content = build()
    let context = AssertionContext()
    context.assert(content)
    return TestResults(failures: context.failures)
}

#if canImport(XCTest)
import XCTest

public func xcTest<Content: Assertion>(@AssertionBuilder build: () -> Content) {
    let results = test(build: build)
    results.xcTest()
}
#endif
