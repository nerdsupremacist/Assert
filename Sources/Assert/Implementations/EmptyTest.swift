
import Foundation

public struct EmptyTest: Test {
    public typealias Body = Never

    public var body: Never {
        fatalError()
    }
}

extension EmptyTest: InternalTest {

    func test(_ context: TestContext) {
        // no-op
    }

}
